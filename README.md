# Secken

A Ruby Interface to Secken API.

## Installation

    $ gem install secken

## Usage

配置

```ruby
client = Secken::Client.new do |config|
  config.app_id  = 'YOUR_APP_ID'
  config.app_key = 'YOUR_APP_KEY'
  config.auth_id = 'YOUR_AUTH_ID'
end
```

获取用户绑定二维码地址

```ruby
client.qrcode_for_binding
```

获取用户登陆二维码地址

```ruby
client.qrcode_for_auth
```

获取用户绑定、登陆、认证结果，可轮询使用

```ruby
client.event_result
```

其他

```ruby
client.auth_page
client.realtime_authorization
client.offline_authorization
```

## Documentation

[https://www.yangcong.com/api](https://www.yangcong.com/api)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/secken. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

