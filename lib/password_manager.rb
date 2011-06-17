require 'highline'
require 'highline/import'

require 'openssl'
require 'base64'

module PasswordManager
  def self.config_path=(config_path)
    @config_path = config_path
    Dir.mkdir(@config_path) unless Dir.exists?(@config_path)
  end

  def self.generate(group)
    group ||= 'default'
    key_pair = OpenSSL::PKey::RSA.generate 1024

    password    = ask_password false
    store_keys group, key_pair, password
  end

  def self.change_password(group)
    password     = ask("Password:"){ |q| q.echo = '*' }
    new_password = ask_password false

    rsa = OpenSSL::PKey::RSA.new File.read( group_path(group) ), password
    store_keys group, rsa, new_password
  end

  def self.export(group)
    password     = ask("Password:"){ |q| q.echo = '*' }
    new_password = ask_password false

    rsa = OpenSSL::PKey::RSA.new File.read( group_path(group) ), password
    store_keys group, rsa, new_password, "#{group}.pem"
  end

  def self.import(group)
    password     = ask("Password:"){ |q| q.echo = '*' }
    new_password = ask_password false

    rsa = OpenSSL::PKey::RSA.new File.read( "#{group}.pem" ), password
    store_keys group, rsa, new_password
  end

  def self.remove(group)
    if self.get('whatever', group)
      File.delete group_path(group)
    else
      false
    end
  rescue
    false
  end

  def self.list
    Dir.glob(File.join @config_path, "*.pem").map{ |x| File.basename(x).match(/([^\.]*)\./)[1] }
  end

  def self.get(service, group, size = nil)
    group ||= 'default'
    size  ||= 16
    rsa      = OpenSSL::PKey::RSA.new File.read( group_path group ), ask_password
    Base64.encode64(rsa.private_encrypt(service)).gsub(/[\+\/]/, '').chomp[0..size.to_i]
  rescue
    puts "Invalid password or group or something else"
  end

  def self.group_path(group)
    File.join @config_path, "#{group}.pem"
  end

  def self.store_keys(group, rsa, password, path = group_path(group))
    cipher      = OpenSSL::Cipher::Cipher.new 'aes-256-cbc'
    private_key = rsa.to_pem cipher, password
    public_key  = rsa.public_key.to_pem cipher, password
    File.open(path, 'w'){ |f| f.puts(private_key + public_key) }
  end

  def self.ask_password(confirmed = true)
    password = ask("Password:"){ |q| q.echo = '*' }
    return password if confirmed

    raise "Passwords didn't match" if ask("Confirm password:"){ |q| q.echo = '*' } != password
    password
  end
end
