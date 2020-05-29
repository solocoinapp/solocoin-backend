set :stage, :prod
set :rails_env, :production
set :log_level, :debug
server 'ec2-13-233-75-179.ap-south-1.compute.amazonaws.com', user: 'deploy', roles: %w{app db web}
set :sidekiq_processes, 1
set :ssh_options, {:forward_agent => true}
