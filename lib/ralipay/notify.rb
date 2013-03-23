require 'ralipay/common'
require 'uri'
require 'cgi'
require 'nokogiri'

include Ralipay::Common

class Notify

  def initialize

  end

  #对return_url的认证,以hash symbol方式输入get数组
  def return_verify? gets
    #@todo 入参合法性验证
    in_hash = Ralipay::Common::para_filter gets
    sort_hash  = in_hash.sort
    sign = CGI::unescape gets[:sign]

    for_sign_string = Ralipay::Common::create_link_string(sort_hash)
    Ralipay::Common::verify?(for_sign_string, sign)
  end

  #对notify_url的认证,以hash symbol方式输入post数组
  def notify_verify? posts
    #@todo 入参合法性验证
    #此处为固定顺序，支付宝Notify返回消息通知比较特殊，这里不需要升序排列
    notify_hash = {
        :service		 => posts[:service],
        :v				   => posts[:v],
        :sec_id		   => posts[:sec_id],
        :notify_data => posts[:notify_data]
    }
    #解密notify_data
    notify_hash[:notify_data] = Ralipay::Common::decrypt notify_hash[:notify_data]
    sign = posts[:sign]
    for_sign_string = Ralipay::Common::create_link_string(notify_hash,false)
    Ralipay::Common::verify?(for_sign_string, sign)
  end

end