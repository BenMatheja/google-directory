$:.push File.expand_path("../lib", __FILE__)
require 'google-directory/version'

Gem::Specification.new do |s|
  s.name = 'google-directory'
  s.version = GoogleDirectory::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Ben Matheja']
  s.email = ['ben.matheja@zweitag.de']
  s.homepage = 'http://www.zweitag.de/'
  s.summary = 'Returns Users from Google Directory'
  s.description = s.summary
  s.bindir = 'bin'
  s.executables = ['users']
  s.has_rdoc = false

  s.add_dependency 'google-api-client', '~> 0.6.2'
  s.add_dependency 'jwt', '~> 0.1.4'
  s.add_dependency 'mime-types'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end
