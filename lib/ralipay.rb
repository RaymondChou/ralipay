module Ralipay

  require 'ralipay/version'
  require 'ralipay/common'
  require 'ralipay/service'
  require 'json'
  require 'date'

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
    $v                   = '2.0'

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
      result = Service.new.mobile_merchant_pay_channel params

      begin
        json = JSON.parse result
      rescue SignOrVerifyError
        #验签异常,可能为证书错误,参数初始化错误
        fail('------SignOrVerifyError------')
      end

      #参数及验签正常,继续生成请求支付请求页面url
      #构造请求参数
      req_hash = {
          :req_data => '<direct_trade_create_req><subject>'   \
                    + $global_configs[:subject]               \
                    + '</subject><out_trade_no>'              \
                    + $global_configs[:out_trade_no]          \
                    + '</out_trade_no><total_fee>'            \
                    + $global_configs[:total_fee]             \
                    + "</total_fee><seller_account_name>"     \
                    + $global_configs[:seller_email]          \
                    + "</seller_account_name><notify_url>"    \
                    + $global_configs[:notify_url]            \
                    + "</notify_url><out_user>"               \
                    + $global_configs[:out_user]              \
                    + "</out_user><merchant_url>"             \
                    + $global_configs[:merchant_url]          \
                    + "</merchant_url><cashier_code>"         \
                    + "</cashier_code><call_back_url>"        \
                    + $global_configs[:call_back_url]         \
                    + "</call_back_url></direct_trade_create_req>",
          :service => $service1,
          :sec_id  => $sec_id,
          :partner => $global_configs[:partner],
          :req_id  => DateTime.parse(Time.now.to_s).strftime('%Y%m%d%H%M%S').to_s,
          :format  => $format,
          :v       => $v
      }

      #获取token
      token = Service.new.alipay_wap_trade_create_direct(req_hash)

      #构造要请求的参数数组，无需改动
      req_hash = {
          :req_data		   => "<auth_and_execute_req><request_token>" \
                              + token                               \
                              + "</request_token></auth_and_execute_req>",
          :service		   => $service2,
          :sec_id		     => $sec_id,
          :partner		   => $global_configs[:partner],
          :call_back_url => $global_configs[:call_back_url],
          :format		     => $format,
          :v				     => $v
      }

      #调用alipay_Wap_Auth_AuthAndExecute接口方法,生成支付地址
      wap_pay_url = Service.new.alipay_wap_auth_and_execute(req_hash)
      return wap_pay_url
    end

  end

end
