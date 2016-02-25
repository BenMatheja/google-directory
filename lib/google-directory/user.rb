require 'fileutils'
require 'json'

module GoogleDirectory
  class User

    #private_class_method :new

    def self.fetch
      new.tap do |instance|
        instance.users
      end
    end

    def api
      GoogleDirectory::Api.instance
    end

    def users
      api.users.users
    end
 
  end
end

