require File.join(File.dirname(__FILE__), 'helper')

class LazyLoadTest < TestCase


  # helpers:

  def with_mappings(*args)
    LazyLoad.map(:StringIO, 'stringio', 'stringio not in stdlib?')
    LazyLoad.map(:Bogus, 'thishastobebogusnow', 'bogus lib not found')
    LazyLoad.map(:Message) { 'love' }
    LazyLoad.map(:Unavailable) do
      raise LazyLoad::DependencyError, 'not available'
    end
    LazyLoad.group(:test_grp, :Bogus, :Unavailable, :Message)
    yield
    LazyLoad.reset!
  end


  # basic

  test 'raises name error' do
    assert_raises(NameError) do
      LazyLoad::Nonexistant
    end
  end

  test 'requires existing' do
    with_mappings do
      assert LazyLoad::StringIO == StringIO
    end
  end

  test 'require fails with message when unavailable' do
    with_mappings do
      assert_raises(LazyLoad::DependencyError) do
        LazyLoad::Bogus
      end
    end
  end

  test 'callback' do
    with_mappings do
      assert LazyLoad::Message == "love"
    end
  end

  test 'callback with dependency error' do
    with_mappings do
      assert_raises(LazyLoad::DependencyError) do
        LazyLoad::Unavailable
      end
    end
  end


  # first_available

  test 'returns first when first available is first' do
    with_mappings do
      assert_equal(
        'love',
        LazyLoad.best(:Message, :StringIO, :Unavailable)
        )
    end
  end

  test 'returns third when first available is third' do
    with_mappings do
      assert_equal(
        'StringIO',
        LazyLoad.best(:Bogus, :Unavailable, :StringIO, :Message).name
        )
    end
  end
  
  test 'fails with first message when none available' do
    with_mappings do
      assert_raises LazyLoad::DependencyError do
        LazyLoad.best(:Bogus, :Unavailable, :Bogus)
      end
    end
  end


  # new_scope

  test 'scope independent of source' do
    with_mappings do
      scope = LazyLoad.scope
      scope.map(:StringIO, 'not_anymore')

      assert_equal('StringIO', LazyLoad::StringIO.name)
      assert_raises(LazyLoad::DependencyError) do
        scope::StringIO
      end
    end
  end

  test 'groups' do
    with_mappings do
      assert_equal 'love', LazyLoad[:test_grp]
    end
  end
  
end



