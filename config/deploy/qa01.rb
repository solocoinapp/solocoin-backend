set :stage, :qa01
set :rails_env, :production
set :log_level, :debug
server '52.78.25.78', user: 'deploy', roles: %w{app db web}
set :sidekiq_processes, 1
