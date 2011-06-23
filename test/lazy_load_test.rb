require File.join(File.dirname(__FILE__), 'helper')

class LazyLoadTest < TestCase


  # helpers:

  def with_mappings(*args)

    mappings = Proc.new do
      const(:StringIO, 'stringio')
      const(:Bogus, 'thishastobebogusnow')
      const(:Message) { 'love' }
      const(:Boat) { 'sank' }
      const(:Unavailable) { raise LoadError, 'not available' }
      group(:test_grp, :Bogus, :Unavailable, :Message)
      wrap(:Boat) { def actually; 'floats'; end }
    end

    LazyLoad.module_eval(&mappings)
    yield(LazyLoad)
    LazyLoad.reset!

    yield LazyLoad.scope(&mappings)

    mod = Module.new
    mod.extend(LazyLoad::Mixin)
    mod.module_eval(&mappings)
    yield mod

  end


  # basic

  test 'raises name error' do
    assert_raises(NameError) do
      LazyLoad::Nonexistant
    end
  end

  test 'requires existing' do
    with_mappings do |ll|
      assert ll::StringIO == StringIO
    end
  end

  test 'require fails with message when unavailable' do
    with_mappings do |ll|
      assert_raises(LoadError) do
        ll::Bogus
      end
    end
  end

  test 'callback' do
    with_mappings do |ll|
      assert ll::Message == "love"
    end
  end

  test 'callback with dependency error' do
    with_mappings do |ll|
      assert_raises(LoadError) do
        ll::Unavailable
      end
    end
  end


  # first_available

  test 'returns first when first available is first' do
    with_mappings do |ll|
      assert_equal(
        'love',
        ll.best(:Message, :StringIO, :Unavailable)
        )
    end
  end

  test 'returns third when first available is third' do
    with_mappings do |ll|
      assert_equal(
        'StringIO',
        ll.best(:Bogus, :Unavailable, :StringIO, :Message).name
        )
    end
  end
  
  test 'fails with first message when none available' do
    with_mappings do |ll|
      assert_raises LoadError do
        ll.best(:Bogus, :Air, :Unavailable, :Bogus)
      end
      assert_raises NameError do
        ll.best(:Air, :Bogus, :Unavailable, :Bogus)
      end
    end
  end


  # new_scope

  test 'scope independent of source' do
    with_mappings do |ll|
      scope = ll.scope
      scope.const(:StringIO, 'not_anymore')

      assert_equal('StringIO', ll::StringIO.name)
      assert_raises(LoadError) { scope::StringIO }
    end
  end

  test 'groups' do
    with_mappings do |ll|
      assert_equal 'love', ll[:test_grp]
    end
  end

  test 'wrapper' do
    with_mappings do |ll|
      assert_equal 'sank',   ll::Boat.wrapped
      assert_equal 'floats', ll::Boat.actually
    end
  end
  
end



