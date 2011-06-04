
LazyLoad
========

**Unobtrusively autoload code with callbacks and helpful errors**

---

LazyLoad is a more elaborate alternative to the [autoload](http://ruby-doc.org/core/classes/Module.html#M000443) method. For instance, it allows setting up callbacks to be invoked when a certain constant is referenced. It is used in scenarios where you need to "soft require" something -- typically to find the "best available" implementation of something, or fail gracefully when dependencies are not met.

Unlike autoload, LazyLoad is scoped, and it does therefore not pollute or monkey patch. What this means is: When you register a callback for the `Foo` constant, referencing `LazyLoad::Foo` will trigger the callback. Simply referencing `Foo` will not trigger the callback.

### Samples

```bash
  
  gem install lazy_load`

```

```ruby

  LazyLoad.map(:Tilt, 'tilt',
    'Tilt not found. Possible fix: gem install tilt')

  # or equivalent with a callback:

  LazyLoad.map(:Tilt) do
    begin
      require 'tilt'
      Tilt
    rescue LoadError
      raise(LazyLoad::DependencyError,
        'Tilt not found. Possible fix: gem install tilt')
    end
  end

  Tilt
  # => NameError: uninitialized constant Object::Tilt

  LazyLoad::Tilt
  # => Tilt

  # or if Tilt is not available:
  
  LazyLoad::Tilt
  # => LazyLoad::DependencyError: Tilt not found. Possible fix: gem install tilt'

  LazyLoad::Foo
  # => NameError: uninitialized constant LazyLoad::Foo

```

Notice how, when a block is used, it must return the constant. The help message is optional. LazyLoad has no mappings by default.


### Best available

TODO


### Scopes

TODO

`LazyLoad::DependencyError`



---

© 2011 Jostein Berre Eliassen. See LICENSE for details.
