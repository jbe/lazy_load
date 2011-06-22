


module LazyLoad

  VERSION = '0.0.3'

  class DependencyError < NameError;  end

  module Methods

    def reset!
      @messages = {}
      @actions  = {}
      @groups   = {}
      self
    end

    def scope(&blk)
      mod = Module.new.extend(LazyLoad::Methods).reset!
      mod.module_eval(&blk) if blk
      mod
    end

    def map(name, action=nil, msg=nil, &blk)
      @messages[name] = msg
      @actions[name]  = blk || action || raise(
        ArgumentError, "missing require path or callback")
    end

    def group(name, *constants)
      @groups[name] = constants
    end

    alias :dep :map

    def unmap(name)
      @messages.delete(name)
      @actions.delete(name)
    end

    def const_missing(name)
      k = case action = @actions[name]
        when String then helpful_require(name)
        when Proc   then action.call
        when nil    then super
        else raise "Invalid action for dependency #{action.inspect}"
      end
      const_set(name, k)
    end

    def helpful_require(name)
      begin
        require @actions[name]
        Kernel.const_get(name)
      rescue LoadError
        raise(DependencyError, @messages[name] ||
          "failed to require #{@actions[name].inspect}.")
      end
    end

    # Return the first available dependency from the
    # list of constant names.
    #
    def best(*names)
      expand_groups(names).each do |name|
        begin
          return const_get(name)
        rescue NameError; end
      end
      const_get(names.first)
    end
    alias :first_available :best
    alias :[] :best

    def expand_groups(names)
      names.map do |name|
        @groups[name] || name
      end.flatten
    end

  end

  extend Methods
  reset!

end

