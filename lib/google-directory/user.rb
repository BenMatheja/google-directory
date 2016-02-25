require 'fileutils'
require 'json'

module GoogleDirectory
  class User
    
    def api
      GoogleDirectory::Api.instance
    end

    def users
      api.users.users
    end
 
  end
end

