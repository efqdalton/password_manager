# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "password_manager/version"

Gem::Specification.new do |s|
  s.name        = "password_manager"
  s.version     = PasswordManager::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dalton Pinto"]
  s.email       = ["dalthon@alun.ita.br"]
  s.homepage    = ""
  s.summary     = %q{A very simple password manager for more secure passwords}
  s.description = %q{A very simple password manager for more secure passwords}

  s.rubyforge_project = "password_manager"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'clipboard', '>= 0.9.0'
end
