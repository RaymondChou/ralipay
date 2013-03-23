# Ralipay

A ruby Gem for Alipay, contains web payment and mobile client payment

## Installation

Add this line to your application's Gemfile:

    gem 'ralipay'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ralipay

## API

    Ralipay::WapPayment.new

    Ralipay::WapPayment.generate_pay_url

    Ralipay::WapPayment.callback_verify?

    Ralipay::WapPayment.callback_verify

    Ralipay::WapPayment.notify_verify?

    Ralipay::WapPayment.notify_verify

    Ralipay::ClientPayment.notify_verify?

    Ralipay::ClientPayment.notify_verify

    Ralipay::ClientPayment.callback_verify?

    Ralipay::Common::build_sign

    Ralipay::Common::create_link_string

    Ralipay::Common::rsa_sign

    Ralipay::Common::md5_sign

    Ralipay::Common::verify?

    Ralipay::Common::para_filter

    Ralipay::Common::decrypt


## Usage

### 准备

- 申请你的支付宝商户服务

- 取调用支付宝支付接口的账户信息

- 并使用openssl工具生成好公钥与私钥(建议使用RSA加密方式)

### 生成一个商品的WAP支付地址

准备好参数:configs(hash symbol)

    configs = {
            :partner => '0000000000000',  #商户id partner_id
            :seller_email => 'service@iiseeuu.com',  #商户email
            :rsa_private_key_path => '/Users/ZhouYT/Desktop/rsa_private_key.pem',  #私钥绝对路径
            :rsa_public_key_path  => '/Users/ZhouYT/Desktop/alipay_public_key.pem',  #公钥绝对路径
            :subject => '测试商品',  #商品名称
            :out_trade_no => '1222222233',  #外部交易号,不能重复
            :total_fee => '0.01',  #交易价格
            :notify_url => 'http://xx.xx.xx.xx/xx/xx',  #服务器异步回调通知接口地址
            :merchant_url => 'http://xx.xx.xx.xx/xx/xx',  #商品展示地址
            :call_back_url => 'http://xx.xx.xx.xx/xx/xx'  #支付成功同步回调跳转地址
        }
获取url

    url = Ralipay::WapPayment.new(configs).generate_pay_url

将当前页面redirect到该url上

### wap支付同步回调页面callback_url(get方法)

同样需要上面的configs(hash symbol),在new的时候只需要配置公钥和私钥就可以了

准备好当前页面获取到的get请求获取到的所有参数与值,用hash symbol形式传入

    Ralipay::WapPayment.new(configs).callback_verify?(gets)

callback_verify? 方法只返回bool

callback_verify 方法返回支付状态,并安全的返回回调参数hash,失败返回false

返回的hash内容:

    :trade_no
    :out_trade_no

### wap支付异步回调接口notify_url(post方法)

同样需要上面的configs(hash symbol),在new的时候只需要配置公钥和私钥就可以了

准备好当前页面获取到的post请求获取到的所有参数与值,用hash symbol形式传入

    Ralipay::WapPayment.new(configs).notify_verify?(posts)

异步回调验证,支付宝主动通知,前端POST xml方式获得参数,该方法只返回bool

成功请自行向支付宝打印纯文本success

如验签失败或未输出success支付宝会24小时根据策略重发总共7次,需考虑重复通知的情况

notify_verify? 方法只返回bool

notify_verify 方法返回支付状态,并安全的返回回调参数hash,失败返回false

### 客户端sdk支付异步回调通知接口notify_url(post方法)

同样需要上面的configs(hash symbol),在new的时候只需要配置公钥和私钥就可以了

准备好当前页面获取到的post请求获取到的所有参数与值,用hash symbol形式传入

    Ralipay::ClientPayment.new(configs).notify_verify?(posts)

此方法与wap支付一致,内部处理有所不同

### 客户端sdk支付同步验证callback_url(post方法)

客户端callback回调之后POST请求服务器callback_url

前端处理时在验签通过就给客户端返回2，不通过就返回1

    Ralipay::ClientPayment.new(configs).callback_verify?(posts)

该方法可以不使用

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
