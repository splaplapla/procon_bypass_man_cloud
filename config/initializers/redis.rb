ActiveSupport::Reloader.to_prepare do
  redis = Redis.new(url: ENV['REDIS_URL'])
  redis_namespace = Redis::Namespace.new(:procon_performance_metric, redis: redis)
  ProconPerformanceMetric::Base.redis = ConnectionPool::Wrapper.new(size: 5, timeout: 3) { redis_namespace }
end
