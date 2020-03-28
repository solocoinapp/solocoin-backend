namespace :development_tasks do

  desc "Seed data for local development"
  task seed_dev_data: :environment do
    user = User.find_or_initialize_by(mobile: "8866553322")
    user.save_provider_auth_user
    user.update!(auth_token: 'yEU27a78WEcH-sGWMeSs', name: 'User 1')
    user.identities.find_or_create_by(provider: 'mobile', uid: '3283nnnasgdykk12')
  end
end