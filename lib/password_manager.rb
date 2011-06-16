require 'openssl'
require 'base64'

module PasswordManager
  def self.config_path=(config_path)
    @config_path = config_path
    Dir.mkdir(@config_path) unless Dir.exists?(@config_path)
  end

  def self.generate
    key_pair = OpenSSL::PKey::RSA.generate 1024
    File.open(File.join(@config_path, 'keys.pem'), 'w'){ |f| f.puts key_pair.to_s }
  end

  def self.get(service, size)
    size ||= 16
    rsa = OpenSSL::PKey::RSA.new File.read( File.join(@config_path, 'keys.pem') )
    Base64.encode64(rsa.private_encrypt(service)).gsub(/[\+\/]/, '').chomp[0..size.to_i]
  end
end
