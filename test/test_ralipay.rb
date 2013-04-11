# coding: utf-8
require 'test/unit'
require 'ralipay'

class TestRalipay < Test::Unit::TestCase

  #def test_generate_wap_pay_url
  #  configs = {
  #      :partner => '2088701817081672',
  #      :seller_email => 'service@iiseeuu.com',
  #      :rsa_private_key_path => '/Users/ZhouYT/Desktop/rsa_private_key.pem',
  #      :rsa_public_key_path  => '/Users/ZhouYT/Desktop/alipay_public_key.pem',
  #      :subject => '测试商品',
  #      :out_trade_no => '1222222233',
  #      :total_fee => '0.01',
  #      :notify_url => 'http://180.110.74.118/post.php',
  #      :merchant_url => 'http://www.iiseeuu.com',
  #      :call_back_url => 'http://www.iiseeuu.com'
  #  }
  #  assert_equal "需要手动访问url进行测试",
  #               Ralipay::WapPayment.new(configs).generate_pay_url
  #end

  #def test_callback_verify
  #  configs = {
  #      :partner => '2088701817081672',
  #      :seller_email => 'service@iiseeuu.com',
  #      :rsa_private_key_path => '/Users/ZhouYT/Desktop/rsa_private_key.pem',
  #      :rsa_public_key_path  => '/Users/ZhouYT/Desktop/alipay_public_key.pem',
  #      :subject => '测试商品',
  #      :out_trade_no => '1222222232',
  #      :total_fee => '1',
  #      :notify_url => 'http://180.110.74.118/post.php',
  #      :merchant_url => 'http://www.iiseeuu.com',
  #      :call_back_url => 'http://www.iiseeuu.com'
  #  }
  #  #'out_trade_no=1222222232&request_token=requestToken&result=success&trade_no=2013032325639837&sign=cANAWkI1dgF1WeyRpp%2F0xzfKXXo50JxRyUxcDh6z%2BZbps1YFiWYRTSUmdCx7HT%2BjAG79ebMWEVIf2HmdIYEIzQDJwu2nl0fElqRgcm9%2BT%2B5b75DbtUg9COla1tr34NLpOcM0P0lcq6byNM0wFbdycUIIoH5Z6JKu66B1YuQLNag%3D&sign_type=0001'
  #  gets = {
  #      :out_trade_no => '1222222232',
  #      :request_token  => 'requestToken',
  #      :result => 'success',
  #      :trade_no => '2013032325639837',
  #      :sign => 'cANAWkI1dgF1WeyRpp%2F0xzfKXXo50JxRyUxcDh6z%2BZbps1YFiWYRTSUmdCx7HT%2BjAG79ebMWEVIf2HmdIYEIzQDJwu2nl0fElqRgcm9%2BT%2B5b75DbtUg9COla1tr34NLpOcM0P0lcq6byNM0wFbdycUIIoH5Z6JKu66B1YuQLNag%3D',
  #      :sign_type => '0001'
  #  }
  #  assert_equal true,
  #               Ralipay::WapPayment.new(configs).callback_verify?(gets)
  #end

  #def test_notify_verify
  #  configs = {
  #      :partner => '2088701817081672',
  #      :seller_email => 'service@iiseeuu.com',
  #      :rsa_private_key_path => '/Users/ZhouYT/Desktop/rsa_private_key.pem',
  #      :rsa_public_key_path  => '/Users/ZhouYT/Desktop/alipay_public_key.pem',
  #      :subject => '测试商品',
  #      :out_trade_no => '1222222233',
  #      :total_fee => '1',
  #      :notify_url => 'http://180.110.74.118/post.php',
  #      :merchant_url => 'http://www.iiseeuu.com',
  #      :call_back_url => 'http://www.iiseeuu.com'
  #  }
  #  posts = {
  #      :service => 'alipay.wap.trade.create.direct',
  #      :sign => 'pCEWVfxBWqvpndkXmCPbd70Tqfo7IG3tP68WmH4wWuUDylb6Rv2RzOghs7m+ANtAx+NyCIuE4KpoonS4qZrc16Qh7/bnwZL2C4FHQJ903HrV0c4n/Pdko0owksnb9VYUGMEppVEBvYPap0bP1GZsbCtI1iuXb2cI1h4vlKJjdGw=',
  #      :sec_id => '0001',
  #      :v => '1.0',
  #      :notify_data => 'Ych9Cg/zaLHsqaBePwoFtxAE7vX0ZvslWCLFTP1AdsxQgvrEcwflAFdbhIHgqsy8AZdRGp7rNeP1Bpn9v+feNlHD96RQit4p1/JHTAOfdoNmQsRaDvBNH9xUlCANXC4zTFDxCZEJN79ppSAzhOu1iMAdUOzim+ZAacxpkMfM4c+YSkpXrEK7kt3Lw4FpkJwwkRAUlYNtrlva94Qo6RZDmo4UpDlUyS1GkqIOihnwxzE4rDO84txzVWtdGDD+Il5ev7nVwnbcsaJzbhl7jgkg8+KzcoIibrn8QJy/xsSckwXZ2pq9Q2d+ufOd/zqpeUvTaD9nNbaH0UYZXDzKPnS91au6zk/2Nqe1d+TsNBeU7muQTM719y7btzfq6tRjs2eNdOfinIYK/MC0lypYtakHrIxpxqyKe1UlpyIVwUauKBkzmJP03x4FJOC7jsbVxI7N2Um/7qlAYCIzLog+SvjW3RX7dhjXAG72qJ93yrTySMJE4yvHEhSFfc2EgjepMzVlCNLwlENrvzkTiqs6rdrKmReKLr2D4QETC5qPL+v3S1iEdlPN4z0KKxp1RWzdwNfLtOceas+lx8oNM2AiQ4O0Y8+YDI/NX7xjckPzwPsEfNWYnwfLYb3MkbmIfhRVozQtsVI4VfxLX35bSQLVtKPdAM4foUIZFh0+HGM+qiSNtZQ2BWjmOUFvIdNyrxMzrRF2+BnuoP+lCkOvQdOnWNoBFpD8aUQrD48AJHQTeyf63bSeJ5Vdif/LPpeJjL+FkP/k+h6mcvigIo1ZcOoF9S2Gg20EgXZWggqR7RLnkroCaNbn/86gZsDQvtwn855n3PRQxosw8a/0F5uFIt/oD5zI7TDFv+p3q9SO3+GYaOwd6OHK3hS11kx2EpzYWw9PaFoANsER9r9buKvQDfcJDkxeN79qmP2zuznVq9OM5X9wDFy2WiFfyYl/swuvZN5e9Q2c0MXj9aeA2H464Am+iFOv1lBWGOlxyVsTQuFjRzRg4FIOp8cv0qOtI/UQPWGbGAy4qys7+sJN/wkboLpdWKLhwgPzto9TM0jN5GZMeA35+2wGcuPAe/SNqhvWM9r8xeCniuSDjesHWWN5bkiYzB4cb0n+E72Yh5WmwJw87ySuXAQWgONxnzgjX0LAGiinoBoufBqmpi/f8vAV3sJFEzkGZxFLSO1Us1ldSi16IqnPTdNtaQAe0N+QYnALM10rmsuGp4/jJatFWFMnmi06AMLcC31who0SD/xItGl6riSkX0yDqWQJzCvZUrrZJoqXJ7XBZoCQscL3Ug2RCKrGba/Ekc10EQINiX99XzYUPVK8xKxO4WW/7T00rZ8B1YjnUaBdWKGdmWmv0itnLx6rK8NWBw=='
  #  }
  #  assert_equal true,
  #               Ralipay::WapPayment.new(configs).notify_verify?(posts)
  #end

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