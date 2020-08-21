namespace :add_referral do

  desc "Add Referral to User"
  task user: :environment do
    User.find_each do |user|
    	Referral.create(
    		code: SecureRandom.alphanumeric,
    		amount: 500,
    		referrals_count: 0,
    		referrals_amount: 0.0,
    		user_id: user.id
    	)
    end
  end
end