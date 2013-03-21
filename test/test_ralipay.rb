require 'test/unit'
require 'ralipay'

class TestRalipay < Test::Unit::TestCase

  def test_generate_wap_pay_url
    assert_equal "test",
      Ralipay::Payment.new({:sign_type => 'DSA'}).wap_pay_url
  end

end