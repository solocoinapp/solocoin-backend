resource "aws_elasticache_cluster" "coronagoapp_redis" {
  cluster_id           = "coronagoapp-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
}
