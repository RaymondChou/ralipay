require 'common'
require 'uri'
require 'net/http'

include Common

class Service

  @gateway_pay_channel = 'https://mapi.alipay.com/cooperate/gateway.do?'
  @gateway_order       = 'http://wappaygw.alipay.com/service/rest.htm?'
  @my_sign          #签名结果
  @parameter_array  #需要签名的数组
  @format           #编码格式
  @req_data = ''    #post请求数据

  def initialize

  end

  #创建mobile_merchant_pay_channel接口
  def mobile_merchant_pay_channel(parameter_array)
    #除去数组中的空值和签名参数
    @parameter_array = Common::para_filter parameter_array
    sort_array = parameter_array.sort

    #生成签名
    @my_sign = Common::build_sign sort_array, $global_config[:sign_type]

    #创建请求数据串
    @req_data = Common::create_link_string(@parameter_array + @req_data)
              + '&sign='
              + URI::encode(@my_sign)
              + '&sign_type='
              + $sec_id

    result = Net::HTTP.get @gateway_pay_channel

    puts result

    alipay_channel = result.response_handle

    #处理JSON
    return alipay_channel
  end

  #验签并反序列化Json数据
  def response_handle

  end

end