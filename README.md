
LazyLoad
========

**Unobtrusively autoload code with callbacks and helpful errors**

---

LazyLoad is a more elaborate alternative to the [autoload](http://ruby-doc.org/core/classes/Module.html#M000443) method. For instance, it allows setting up callbacks to be invoked when a certain constant is referenced. It is used in scenarios where you need to "soft require" something -- typically to find the "best available" implementation, or fail gracefully when dependencies are not met.

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


### Errors

Referencing a constant beneath `LazyLoad` for which there is no mapping resuslts in the usual `NameError`. Referencing an unavailable constant typically gives a `LazyLoad::DependencyError`, which conveniently is also a subclass of `NameError`.


### Best available

You can use the `best` method to return the first constant from a list of names, or else raise a `LazyLoad::DependencyError` for the first (most preferred) one.

```ruby
    LazyLoad.best(:Kramdown, :RDiscount, :Redcarpet)

```


### Scopes

Use the `scope` method if you need more than one scope (typically for gem interoperability).

```ruby
  module SomeProject
    Lazy = LazyLoad.scope do
      map(:StringIO, 'stringio')
    end
    
    Lazy.map(:Tilt, 'tilt')
  
    Lazy::StringIO # => StringIO
    Lazy::Tilt # => Tilt
  end
```

Feedback and suggestions are welcome through Github.

---

© 2011 Jostein Berre Eliassen. See LICENSE for details.
