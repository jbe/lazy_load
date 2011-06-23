


module LazyLoad

  VERSION = '0.0.3'

  module Mixin

    def reset!
      @actions  = {}
      @groups   = {}
      @wrappers = {}
      self
    end

    def self.extended(obj)
      obj.reset!
    end

    def scope(&blk)
      mod = Module.new.extend(LazyLoad::Mixin).reset!
      mod.module_eval(&blk) if blk
      mod
    end

    def const(name, action=nil, &blk)
      @actions[name]  = blk || action || raise(
        ArgumentError, "missing require path or callback")
    end
    alias :dep :const

    def group(name, *constants)
      @groups[name] = constants
    end

    def unmap(name)
      @actions.delete(name)
    end

    def const_missing(name)
      k = case action = @actions[name]
        when Proc   then action.call
        when nil    then super
        when String
          require @actions[name]
          Kernel.const_get(name)
        else raise "Invalid action for dependency #{action.inspect}"
      end
      k = @wrappers[name].new(k) if @wrappers[name]
      const_set(name, k)
    end

    # Return the first available dependency from the
    # list of constant names.
    #
    def best(*names)
      names.map do |name|
        @groups[name] || name
      end.flatten.each do |name|
        begin
          return const_get(name)
        rescue NameError, LoadError; end
      end
      const_get(names.first)
    end
    alias :first_available :best
    alias :[] :best

    def wrap(name, &blk)
      kls = Class.new(Wrapper)
      kls.class_eval(&blk)
      @wrappers[name] = kls
    end

    class Wrapper
      def initialize(wrapped)
        @wrapped = wrapped
      end
      attr_reader :wrapped

      def method_missing(*args)
        @wrapped.send(*args)
      end

      def respond_to?(name)
        super || @wrapped.respond_to?(name)
      end
    end

  end

  extend Mixin

end

