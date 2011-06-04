require File.join(File.dirname(__FILE__), 'helper')

class LazyLoadTest < TestCase

  def map(*args)
    LazyLoad.map(*args)
    yield
    LazyLoad.unmap(args.first)
  end

  test 'raises name error' do
    assert_raises(NameError) do
      LazyLoad::Nonexistant
    end
  end

  test 'requires existing'
  test 'require fails with message on nonexisting'
  test 'callback'
  test 'callback with dependency error'

  test 'returns first when first available is first'
  test 'returns third when first available is third'
  test 'fails with first message when none available'

end
