namespace :add_referral do

  desc "Update Referral of User"
  task user: :environment do
    Referral.find_each do |referral|
      referral.update_attributes(code: SecureRandom.alphanumeric(6))
    end
  end
end