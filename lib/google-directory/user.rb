require 'fileutils'
require 'json'

module GoogleDirectory
  class User

    private_class_method :new

    def self.fetch
      new.tap do |instance|
        instance.groups
        instance.users
      end
    end

    def api
      GoogleDirectory::Api.instance
    end

    def users
      puts api.users.users
    end
    
  end
end

