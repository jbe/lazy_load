$:.push File.expand_path('../lib', __FILE__)
require 'lazy_load'

Gem::Specification.new do |s|

  s.name      = 'lazy_load'

  s.author    = 'Jostein Berre Eliassen'
  s.email     = 'josteinpost@gmail.com'
  s.homepage  = "http://github.com/jbe/lazy_load"
  s.license   = "MIT"

  s.version   = LazyLoad::VERSION
  s.platform  = Gem::Platform::RUBY

  s.summary       = 'Autoload with custom callbacks.'

  s.description   = %{LazyLoad is a slightly more elaborate alternative
                    to the autoload method. It provides custom callbacks,
                    "best available" dependency selection, and an optional
                    simple wrapper mechanism.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_path  = 'lib'
end
