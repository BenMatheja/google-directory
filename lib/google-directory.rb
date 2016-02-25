require 'google-directory/version'
require 'google-directory/config'
require 'google-directory/session'
require 'google-directory/api'
require 'google-directory/user'
require 'forwardable'

module GoogleDirectory

  extend SingleForwardable

  def_delegators :'GoogleDirectory::Config', *Config.public_instance_methods(false)

  def self.config(&block)
    block_given? ? yield(Config) : Config
  end
end

#GoogleDirectory::Config.load!
