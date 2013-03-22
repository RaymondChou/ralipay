module Ralipay

  require 'ralipay/version'
  require 'ralipay/common'
  require 'ralipay/service'

  include Ralipay::Common

  class Payment

    #传入参数,必须初始化
    $global_configs = {
      :secure_type   => 'RSA',
      :partner       => '',
      :seller_email  => '',
      :notify_url    => '',
      :call_back_url => '',
      :merchant_url  => '',
      :subject       => '',
      :out_trade_no  => '',
      :total_fee     => '',
      :out_user      => '',
      :rsa_private_key_path => '',
      :rsa_public_key_path  => ''
    }

    #固定参数,无需修改
    $service1            = 'alipay.wap.trade.create.direct'
    $service2            = 'alipay.wap.auth.authAndExecute'
    $format              = 'xml'
    $sec_id              = '0001'
    $input_charset       = 'utf-8'
    $input_charset_gbk   = 'GBK'
    $service_pay_channel = 'mobile.merchant.paychannel'

    def initialize(configs)
      #@todo 入参合法性验证
      $global_configs = $global_configs.merge configs
    end

    def generate_wap_pay_url
      params = {
          :_input_charset => $input_charset_gbk,
          :sign_type      => $sec_id,
          :service        => $service_pay_channel,
          :partner        => $global_configs[:partner],
          :out_user       => ''
      }
      Service.new.mobile_merchant_pay_channel params
    end

  end

end
