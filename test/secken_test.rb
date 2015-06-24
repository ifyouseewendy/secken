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

  def test_auth_page
    assert_kind_of String, @client.auth_page(callback: '')
  end

  def test_realtime_authorization
    assert_raises RuntimeError, /No \w passed/ do
      @client.realtime_authorization
    end

    uid = '' # Fetch your own uid from event_result
    assert 400, @client.realtime_authorization(action_type: 1, uid: uid)['error_code']
  end

  def test_offline_authorization
    assert_raises RuntimeError, /No \w passed/ do
      @client.offline_authorization
    end

    uid = '' # Fetch your own uid from event_result
    dynamic_code = '123123'
    assert 400, @client.offline_authorization(uid: uid, dynamic_code: dynamic_code)['status']
  end

  def test_event_result
    assert_raises RuntimeError, /No \w passed/ do
      @client.event_result
    end

    event_id = @client.qrcode_for_binding['event_id']
    assert 602, @client.event_result(event_id: event_id)['status']
  end

end
