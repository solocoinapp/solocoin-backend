require 'redis'

if ENV['cache_server_url']
  redis = Redis.new(url: ENV['cache_server_url'])
  Rack::Attack.cache.store = Rack::Attack::StoreProxy::RedisStoreProxy.new(redis)
end

# Enables throttling for auth requests to 10rpm
Rack::Attack.throttle("auth requests per ip", limit: 10, period: 1.minute) do |req|
  if ['/api/v1/callbacks/mobile_login', '/api/v1/callbacks/mobile_sign_up'].include?(req.path)
    req.ip
  end
end

# Enables throttling for non auth requests to 40rpm
Rack::Attack.throttle("non auth requests per ip", limit: 40, period: 1.minute) do |req|
  unless ['/api/v1/callbacks/mobile_login', '/api/v1/callbacks/mobile_sign_up'].include?(req.path)
    req.ip
  end
end

ActiveSupport::Notifications.subscribe('throttle.rack_attack') do |name, start, finish, request_id, payload|
  req = payload[:request]

  Rails.logger.info("[Rack::Attack][Blocked]" +
                    "ip: \"#{req.ip}\"," +
                    "path: \"#{req.path}\"")
end
