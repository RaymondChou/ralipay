module Common

  #生成签名结果
  def self.build_sign(data_array, sign_type = 'RSA', rsa_private_key_path = '')
    #把数组所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
    for_sign_string = self.create_link_string(data_array)
    #签名
    if sign_type == 'RSA'
      return self.rsa_sign(for_sign_string,rsa_private_key_path)
    elsif sign_type == 'MD5'
      return self.md5_sign(for_sign_string)
    else
      puts 'Unknown sign_type!'
    end
  end

  #把数组所有元素，排序后按照“参数=参数值”的模式用“&”字符拼接成字符串
  def self.create_link_string(array)
    result_string = ''
    array = array.sort
    array.each{|key,value|
      result_string += (key + '=' + value + '&')
    }
    #去掉末尾的&
    result_string = result_string[0, result_string.length - 1]
    return result_string
  end

  #RSA签名
  def self.rsa_sign(for_sign_string,rsa_private_key_path)
    #读取私钥文件
    #转换为openssl密钥，必须是没有经过pkcs8转换的私钥
    #调用openssl内置签名方法，生成签名
    #base64编码
  end

  #MD5签名
  def self.md5_sign(for_sign_string)

  end

end