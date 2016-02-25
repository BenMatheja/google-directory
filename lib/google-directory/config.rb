require 'pathname'

module GoogleDirectory
  module Config

    CONFIG_DIR = 'config'

    extend self

    attr_accessor :env
    attr_accessor :config_dir
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :client_email

    def env
      @env ||= ENV['DIRECTORY_ENV'] ? ENV['DIRECTORY_ENV'] : 'development'
    end

    def config_dir
      @config_dir ||= find_directory(:config_dir)
    end

    private
    # recursively search upwards for a directory, unless '/' is reached
    def find_directory(name, current = Pathname.new('.'))
      raise "Cannot find directory #{name}" if current.expand_path.root?
      path = current + name
      current.children.include?(path) ? path.expand_path.to_s : find_directory(name, current.parent)
    end
  end
end
