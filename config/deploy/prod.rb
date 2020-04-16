set :stage, :prod
set :rails_env, :production
set :log_level, :debug
server '13.235.18.42', user: 'deploy', roles: %w{app db web}
set :sidekiq_processes, 1
