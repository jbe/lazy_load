
LazyLoad
========

**Autoload with custom callbacks**

---

LazyLoad is a slightly more elaborate alternative to [autoload](http://ruby-doc.org/core/classes/Module.html#M000443). It helps deal with "soft" dependencies, where dependencies are "preferred", rather than strictly needed. It is very simple, but provides:

* Custom callbacks
* "Best available" dependency selection
* A simple, optional wrapper mechanism

Unlike [autoload](http://ruby-doc.org/core/classes/Module.html#M000443), LazyLoad is scoped. This means that when you register a callback for the `Foo` constant, referencing `LazyLoad::Foo` will trigger the callback. Simply referencing `Foo` will not trigger the callback. In other words, internals are not monkey patched. However, you can also use it as a mixin, thereby eliminating the verbosity.

### Samples

```bash
  
  gem install lazy_load`

```

```ruby

  # same as as autoload:

  LazyLoad.const(:Tilt, 'tilt')

  # or the equivalent with a callback:

  LazyLoad.const(:Tilt) do
    require 'tilt'
    Tilt
  end

  # lets you..

  LazyLoad::Tilt # => Tilt (or LoadError)

  LazyLoad::Oboe
  # => NameError: uninitialized constant LazyLoad::Oboe

```

Note that the return value of the callback becomes the constant. Any object can be returneed.


### Best available

You can use the `best` method to return the first constant for which the callback does not raise a `LoadError`, or else raise the `LoadError` of the first (most preferred) constant:

```ruby

    LazyLoad.best(:Kramdown, :RDiscount, :Redcarpet)

    # or using named groups:

    LazyLoad.group(:markdown, :Kramdown, :RDiscount, :Redcarpet)
    LazyLoad.best(:markdown)

```

### Mixin

You can endow objects with the LazyLoad methods by extending the `LazyLoad::Mixin.` Each object will have its own scope of callbacks.

```ruby

  module WidgetFactoryFactory

    extend LazyLoad::Mixin

    const :Haml, 'haml'

    Haml # => Haml

  end

```

### Wrappers

LazyLoad has super simple wrapper support, which lets you quickly define wrapper classes that are automatically wrapped around their corresponding constants. These wrappers get a default `initialize` method, which sets `@wrapped` to the object they wrap, and are set to forward method calls there using `method_missing`.

```ruby

  LazyLoad.wrapper(:RDiscount) do

    def new(*args)
      InstanceWrapper.new(super(*args))
    end

    class InstanceWrapper < LazyLoad::Wrapper

      def render(*args); to_html(*args); end

      def go_shopping
        puts 'sure, why not'
      end

    end

  end

```


&nbsp;

Feedback and suggestions are welcome through Github.

---

© 2011 Jostein Berre Eliassen. See LICENSE for details.
