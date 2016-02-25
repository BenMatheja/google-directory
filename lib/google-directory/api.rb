require 'singleton'
require 'google/api_client'

module GoogleDirectory
  class Api
    extend Forwardable
    include Singleton

    def_delegators :@session, :client, :directory
    def_delegator :@session, :refresh, :refresh_session

    def initialize
      config = GoogleDirectory.config
      @session = Session.new config.client_id, config.client_secret, config.client_email, config.config_dir + '/oauth_data.yml'
    end

    # see https://developers.google.com/admin-sdk/directory/v1/reference/users/list
    def users
      response = call directory.users.list, parameters: { customer: 'my_customer', query: 'isSuspended=false'}
      response.data
    end

    # see https://developers.google.com/admin-sdk/directory/v1/reference/groups/list
    def groups
      response = call directory.groups.list, parameters: { customer: 'my_customer' }
      response.data
    end

    # see https://developers.google.com/admin-sdk/directory/v1/reference/members/list
    def members(group)
      response = call directory.members.list, parameters: { customer: 'my_customer', groupKey: group, maxResults: 200 }
      response.data
    end

    private

    def call(api_method, params={})
      refresh_session

      result = client.execute(
        params.merge( { api_method: api_method } )
      )
      if !result.success?
        puts "An error occurred: #{result.data['error']['message']}"
        nil
      else
        result
      end
    end
  end
end

