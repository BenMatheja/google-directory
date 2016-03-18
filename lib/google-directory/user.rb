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

    def groups
	   api.groups
    end

    def members(id)
      members = api.members(id).members
      users = users()
      users.each do |u|
        if ! members.include?(u['id'])
          users.delete(u)
        end
      end
      users
    end

  end
end

