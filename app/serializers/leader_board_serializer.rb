class LeaderBoardSerializer < ApplicationSerializer
  attributes :top_users, :user
  ALLOWED_USER_ATTRIBUTES = [
    'id',
    'name',
    'profile_picture_url',
    'country_code',
    'wallet_balance'
  ].freeze

  def top_users
    object.top_users.map.each_with_index do |user, i|
      user_hash(user, i + 1)
    end
  end

  def user
    user_hash(object.user, object.user_rank)
  end

  private

  def user_hash(user, rank)
    user.attributes.slice(*ALLOWED_USER_ATTRIBUTES).merge(wb_rank: rank)
  end
end
