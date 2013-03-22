require 'test/unit'
require 'ralipay'

class TestRalipay < Test::Unit::TestCase

  def test_generate_wap_pay_url
    assert_equal "test",
                 Ralipay::Payment.new({:secure_type => 'DSA'}).generate_wap_pay_url
  end

  def test_para_filter
    input_para = {:a => 'abc', :sign_type => 'abc', :c => '', :d => nil}
    assert_equal ({:a => 'abc'}),
                 Ralipay::Common::para_filter(input_para)
  end

  def test_create_link_string
    input_para = {:a => 'abc', :x => 'abcd', :s => '', :d => nil}
    assert_equal 'a=abc&d=&s=&x=abcd',
                 Ralipay::Common::create_link_string(input_para)
  end

end