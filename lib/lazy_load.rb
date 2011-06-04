
# Defer loading (or another required task) until a
# constant is requested. Optionally show helpful
# message when dependencies are not met.
#
module LazyLoad

  class Error < StandardError;    end
  class DependencyError < Error;  end

  @@messages = {}
  @@actions  = {}

  def self.map(name, action=nil, msg=nil, &blk)
    @@messages[name] = msg
    @@actions[name]  = blk || action || raise(
      ArgumentError, "missing require path or callback")
  end

  def unmap(name)
    @@messages.delete(name)
    @@actions.delete(name)
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
  def first_available(*names)
    names.each do |name|
      begin
        return; self.const_get(name)
      rescue NameError; end
    end
    self.const_get(names.first)
  end

end

