require 'google/api_client'
require 'yaml'
require 'launchy'

module GoogleDirectory
  class Session

    REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob'
    SCOPES = [
      'https://www.googleapis.com/auth/admin.directory.user.readonly',
      'https://www.googleapis.com/auth/admin.directory.group.readonly',
      # Add other requested scopes.
    ]

    attr_accessor :oauth_data
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :client_email
    attr_accessor :oauth_data_file

    def initialize(client_id, client_secret, client_email, oauth_data_file, authorization_code = nil)
      @client_id = client_id
      @client_secret = client_secret
      @client_email = client_email
      @oauth_data_file = oauth_data_file
      refresh authorization_code
    end

    def refresh(authorization_code = nil)
      update_token
      if (authorization_code == nil && ! authorized?)
        Launchy.open auth_url
        print "Input text: "
        authorization_code = STDIN.gets.strip
      end
      authorize_code(authorization_code) if authorization_code
      store_oauth_data
    end

    def client
      @client ||= begin
        client = Google::APIClient.new(application_name: 'Directory Client', application_version: GoogleDirectory::VERSION)
        client.authorization.client_id = client_id
        client.authorization.client_secret = client_secret
        client.authorization.redirect_uri = REDIRECT_URI
        client.authorization.scope = SCOPES
        client
      end
    end

    def directory
      @directory ||= client.discovered_api('admin', 'directory_v1')
    end

    def oauth2
      @oauth2 ||= client.discovered_api('oauth2', 'v2')
    end

    def authorized?
      client.authorization.refresh_token && client.authorization.access_token
    end

    # Get oauth_data data from file, if exists
    def oauth_data
      @oauth_data ||= File.exists?(oauth_data_file) ? YAML::load_file(oauth_data_file) : {}
    end

    # Generate the authentication that needs to be opened by client_email user
    def auth_url
      client.authorization.authorization_uri(state: '', approval_prompt: :force, access_type: :offline, user_id: client_email).to_s
    end

    # Make sure access token is up to date for each request
    def update_token
      client.authorization.update_token!(oauth_data)
      if client.authorization.refresh_token && client.authorization.expired?
        client.authorization.fetch_access_token!
      end
    end

    # Store oauth data to file, if modified
    def store_oauth_data
      not_modified = [:access_token, :refresh_token, :expires_in, :issued_at].map do |key|
        oauth_data[key] == (oauth_data[key] = client.authorization.send(key))
      end.all?
      File.open(oauth_data_file,'w') { |f| f.puts oauth_data.to_yaml } unless not_modified
    end

    # Update access token and ensure refresh token is up to date
    def authorize_code(authorization_code)
      client.authorization.code = authorization_code
      client.authorization.fetch_access_token!
      client.authorization.refresh_token ||= oauth_data[:refresh_token]
      oauth_data[:refresh_token] = client.authorization.refresh_token
    end
  end
end
