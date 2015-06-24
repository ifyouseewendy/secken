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

获取用户绑定二维码地址，配合 `event_result` 使用。

```ruby
client.qrcode_for_binding
```

获取用户登陆二维码地址，配合 `event_result` 使用。

```ruby
client.qrcode_for_auth
```

授权页

```ruby
client.auth_page
```

一键认证，配合 `event_result` 使用。

```ruby
client.realtime_authorization(action_type: 1, uid: 'UID')
```

动态码认证

```ruby
client.offline_authorization(uid: 'UID', dynamic_code: 'DYNAMIC_CODE')
```

获取用户绑定、登陆、认证结果，需轮询使用

```ruby
resp = nil
loop do
  break if (resp=client.event_result)['status'] == 200
end
```

## Documentation

[https://www.yangcong.com/api](https://www.yangcong.com/api)

## TODO

1. `callback` param seems don't work in `qrcode_for_binding` and `qrcode_for_auth`
2. Check all the option params in every API

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

