resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = "${var.environment}-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
}
