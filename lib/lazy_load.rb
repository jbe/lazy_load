


module LazyLoad

  VERSION = '0.0.1'

  class Error < StandardError;    end
  class DependencyError < Error;  end

  def self.new_scope(&blk)
    mod = self.dup.reset
    mod.module_eval(&blk)
    mod
  end

  @@messages = {}
  @@actions  = {}

  def self.map(name, action=nil, msg=nil, &blk)
    @@messages[name] = msg
    @@actions[name]  = blk || action || raise(
      ArgumentError, "missing require path or callback")
  end

  def self.unmap(name)
    @@messages.delete(name)
    @@actions.delete(name)
  end

  def reset!
    @@messages.clear
    @@actions.clear
    self
  end

  def self.const_missing(name)
    k = case action = @@actions[name]
      when String then helpful_require(name)
      when Proc   then action.call
      when nil    then super
      else raise "Invalid action for dependency #{action.inspect}"
    end
    const_set(name, k)
  end

  def self.helpful_require(name)
    begin
      require @@actions[name]
      Kernel.const_get(name)
    rescue LoadError
      raise(DependencyError, @@messages[name] ||
        "failed to require #{@@actions[name].inspect}.")
    end
  end

  # Return the first available dependency from the
  # list of constant names.
  #
  def self.first_available(*names)
    names.each do |name|
      begin
        return; self.const_get(name)
      rescue NameError; end
    end
    self.const_get(names.first)
  end

end

