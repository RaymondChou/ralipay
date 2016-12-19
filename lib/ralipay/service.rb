require 'ralipay/common'
require 'uri'
require 'net/http'
require 'cgi'
require 'nokogiri'

include Ralipay::Common

class Service

  @@gateway_pay_channel = 'https://mapi.alipay.com/cooperate/gateway.do?'
  @@gateway_order       = 'http://wappaygw.alipay.com/service/rest.htm?'
  @@my_sign = nil          #签名结果
  @@parameter = nil       #需要签名的hash
  @@format = nil          #编码格式
  @@req_data = ''    #post请求数据

  def initialize

  end

  #创建mobile_merchant_pay_channel接口
  def mobile_merchant_pay_channel parameter

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

    if verify
      return json_result
    else
      fail('------verify fail------')
    end

  end

  #创建alipay.wap.trade.create.direct接口
  def alipay_wap_trade_create_direct parameter
    #除去数组中的空值和签名参数
    @@parameter = Ralipay::Common::para_filter parameter
    sort_array  = @@parameter.sort
    #生成签名
    @@my_sign = Ralipay::Common::build_sign sort_array
    #创建POST请求数据串
    @@req_data = Ralipay::Common::create_link_string(sort_array).to_s \
               + '&sign='                                              \
               + CGI::escape(@@my_sign)
    #请求支付宝接口
    uri  = URI.parse (@@gateway_order)
    http = Net::HTTP.new uri.host, uri.port
    request  = Net::HTTP::Post.new(uri.request_uri)
    request.set_body_internal(@@req_data)
    response = http.request(request)

    #解析token
    token = parse_token response.body
  end

  def parse_token string
    #返回的数据已转义,反转义之
    unescaped_string = CGI::unescape string
    #用&拆开
    unescaped_string = unescaped_string.split('&')
    data_hash = {}
    unescaped_string.each{|str|
      kv_array = str.split('=',2)
      data_hash[kv_array[0]] = kv_array[1]
    }
    #私钥解密
    data_hash['res_data'] = Ralipay::Common::decrypt data_hash['res_data']
    #获取返回的RSA签名
    sign = data_hash['sign']
    #去sign,准备验签
    data_hash = Ralipay::Common::para_filter data_hash
    data_hash.sort
    link_string = Ralipay::Common::create_link_string(data_hash)

    #验签
    verify = Ralipay::Common::verify?(link_string, sign)

    if verify
      #解析token
      doc = Nokogiri::XML data_hash['res_data']
      token = doc.xpath('/direct_trade_create_res/request_token').text
      return token
    else
      fail('------verify fail------')
    end
  end

  #调用alipay_Wap_Auth_AuthAndExecute接口
  def alipay_wap_auth_and_execute parameter
    #除去数组中的空值和签名参数
    @@parameter = Ralipay::Common::para_filter parameter
    sort_array  = @@parameter.sort
    #生成签名
    @@my_sign = Ralipay::Common::build_sign sort_array
    #生成跳转链接
    redirect_url = @@gateway_order                                  \
                 + Ralipay::Common::create_link_string(@@parameter) \
                 + '&sign='                                          \
                 + CGI::escape(@@my_sign)
    return redirect_url
  end

end