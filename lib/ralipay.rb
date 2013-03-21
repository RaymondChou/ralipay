require "ralipay/version"
require "ralipay/common"

include Common

class Ralipay

  #传入参数,必须初始化
  @configs = {
    :partner       => '',
    :seller_email  => '',
    :notify_url    => '',
    :call_back_url => '',
    :merchant_url  => '',
    :subject       => '',
    :out_trade_no  => '',
    :total_fee     => '',
    :out_user      => '',
  }

  #固定参数,无需修改
  @service1            = 'alipay.wap.trade.create.direct'
  @service2            = 'alipay.wap.auth.authAndExecute'
  @format              = 'xml'
  @sec_id              = '0001'
  @input_charset       = 'utf-8'
  @service_pay_channel = 'mobile.merchant.paychannel'

  def initialize(configs)
    @configs = configs
  end

  def wap_pay_url()

  end

end
