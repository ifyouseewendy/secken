require 'test_helper'

class SeckenTest < Minitest::Test
  def setup
    @client = Secken::Client.new do |config|
      config.app_id  = ENV['APP_ID']
      config.app_key = ENV['APP_KEY']
      config.auth_id = ENV['AUTH_ID']
    end
  end

  def test_initialize
    assert @client.instance_of? Secken::Client
    assert @client.config.instance_of? Secken::Configuration
  end

  def test_qrcode_for_binding
    resp = @client.qrcode_for_binding
    assert resp.key?('status')

    if resp['status'] == 200
      assert resp.key?('event_id')
      assert resp.key?('qrcode_url')
    end
  end

  def test_qrcode_for_auth
    resp = @client.qrcode_for_auth(callback: '') # Use ngrok to mock callback
    assert resp.key?('status')

    if resp['status'] == 200
      assert resp.key?('event_id')
      assert resp.key?('qrcode_url')
    end
  end

  def test_event_result
    assert @client.event_id.nil?
    assert 400, @client.event_result['status']

    @client.qrcode_for_binding
    refute @client.event_id.nil?
    assert 602, @client.event_result['status']
  end
end
