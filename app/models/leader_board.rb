class LeaderBoard < ActiveModelSerializers::Model
  LIMIT = 10

  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def top_users
    @top_users ||= User.order('wallet_balance desc').limit(LIMIT)
  end

  def user_rank
    @user_rank ||= if @top_users.include?(user)
                     @top_users.index(user) + 1
                   else
                     User.where('wallet_balance > ?', user.wallet_balance).count + 1
                   end
  end
end
