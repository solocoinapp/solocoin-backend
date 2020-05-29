set :stage, :prod
set :rails_env, :production
set :log_level, :debug
server 'ec2-13-233-75-179.ap-south-1.compute.amazonaws.com', user: 'deploy', roles: %w{app db web}
set :sidekiq_processes, 1
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa) }

# set :ssh_options, {:forward_agent => true}
# ssh_options[:keys] = %w("/home/mohd/Downloads/solocoin_aws_ec2_keys/solocoin_aws_ec2_keys/Prod/prod_16_apr_20.pem")
# ssh_options: {
#     keys: %w("/home/mohd/Downloads/solocoin_aws_ec2_keys/solocoin_aws_ec2_keys/Prod/prod_16_apr_20.pem"),
#     forward_agent: false,
#     auth_methods: %w(publickey)
#   }
