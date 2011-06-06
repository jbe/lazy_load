


module LazyLoad

  VERSION = '0.0.1'

  class DependencyError < NameError;  end

  module Methods

    def reset!
      @messages = {}
      @actions  = {}
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
      names.each do |name|
        begin
          return const_get(name)
        rescue NameError; end
      end
      const_get(names.first)
    end
    alias :first_available :best

  end

  extend Methods
  reset!

end

