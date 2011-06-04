
LazyLoad
========

**Unobtrusively autoload code with callbacks and helpful errors**

---

LazyLoad is a more elaborate alternative to the autoload method. For instance, it allows setting up callbacks to be invoked when a certain constant is referenced. It does not monkey patch or pollute the global namespace. It is typically used in scenarios where you need to "soft require" something; falling back to other implementations when it doesn't work.

Unlike autoload, LazyLoad is scoped. When you register a callback for the `Foo` constant, referencing `LazyLoad::Foo` will try to load it. Simply referencing `Foo` will not trigger the callback.

### Samples

```bash
  
  gem install lazy_load`

```

```ruby

  #TODO

```

#     LazyLoad.map(:Tilt, 'tilt',
#       'Tilt not found. Possible fix: gem install tilt')
# But this: `LazyLoad::Tilt`
#
# or this:
#
#     LazyLoad.map(:Tilt) do
#       begin
#         require 'tilt'
#         Tilt
#       rescue LoadError
#         raise(LazyLoad::DependencyError,
#           'Tilt not found. Possible fix: gem install tilt')
#       end
#     end
#
# Notice how, when a block is used, it must return the constant.
# The help message is optional. LazyLoad has no mappings by default.

Possible results:

* No such constant mapped: `NameError: uninitialized constant`
* Mapped, but not available: `LazyLoad::DependencyError`

---

© 2011 Jostein Berre Eliassen. See LICENSE for details.
