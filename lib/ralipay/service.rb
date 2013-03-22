require 'ralipay/common'
require 'uri'
require 'net/http'
require 'cgi'
require 'nokogiri'

include Ralipay::Common

class Service

  @@gateway_pay_channel = 'https://mapi.alipay.com/cooperate/gateway.do?'
  @@gateway_order       = 'http://wappaygw.alipay.com/service/rest.htm?'
  @@my_sign          #签名结果
  @@parameter        #需要签名的hash
  @@format           #编码格式
  @@req_data = ''    #post请求数据

  def initialize

  end

  #创建mobile_merchant_pay_channel接口
  def mobile_merchant_pay_channel(parameter)

    #除去数组中的空值和签名参数
    @@parameter = Ralipay::Common::para_filter parameter
    sort_array  = @@parameter.sort
    #生成签名
    @@my_sign = Ralipay::Common::build_sign sort_array
    #创建请求数据串
    @@req_data = Ralipay::Common::create_link_string(@@parameter).to_s \
               + '&sign='                                              \
               + CGI::escape(@@my_sign)                                \
               + '&sign_type='                                         \
               + $sec_id

    #请求支付宝接口
    uri  = URI.parse (@@gateway_pay_channel + @@req_data)
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true if uri.scheme == 'https'
    path = uri.query.nil? ? uri.path : uri.path + '?' + uri.query
    xml = http.get2(path).body
    result = response_handle xml
  end

  #验签并反序列化Json数据
  def response_handle xml
    #解析xml
    doc = Nokogiri::XML xml
    json_result = doc.xpath('/alipay/response/alipay/result').text
    ali_sign    = doc.xpath('/alipay/sign').text

    #转换待签名格式数据，因为此mapi接口统一都是用GBK编码的，所以要把默认UTF-8的编码转换成GBK，否则生成签名会不一致
    for_sign_string = 'result=' + json_result
    for_sign_string = for_sign_string.encode('GBK')
    verify = Ralipay::Common::verify?(for_sign_string, ali_sign)

    if verify == true
      return json_result
    else
      fail('------verify fail------')
    end

  end

end