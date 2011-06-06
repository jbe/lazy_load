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

  s.summary       = 'An unobtrusive way to autoload code with callbacks ' +
                    'and helpful errors.'

  s.description   = 'LazyLoad is a more elaborate alternative to the ' +
                    'autoload method. For instance, it allows setting ' +
                    'up callbacks to be invoked when a certain constant ' +
                    'is referenced. It does not monkey patch or ' +
                    'pollute the global namespace.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_path  = 'lib'
end
