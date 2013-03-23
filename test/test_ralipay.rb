require 'test/unit'
require 'ralipay'

class TestRalipay < Test::Unit::TestCase

  def test_generate_wap_pay_url
    configs = {
        :partner => '2088701817081672',
        :seller_email => 'service@iiseeuu.com',
        :rsa_private_key_path => '/Users/ZhouYT/Desktop/rsa_private_key.pem',
        :rsa_public_key_path  => '/Users/ZhouYT/Desktop/alipay_public_key.pem',
        :subject => '测试商品',
        :out_trade_no => '1222222232',
        :total_fee => '1',
        :notify_url => 'http://www.iiseeuu.com',
        :merchant_url => 'http://www.iiseeuu.com',
        :call_back_url => 'http://www.iiseeuu.com'
    }
    assert_equal "需要手动访问url进行测试",
                 Ralipay::Payment.new(configs).generate_wap_pay_url
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