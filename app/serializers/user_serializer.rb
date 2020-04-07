class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :mobile, :profile_picture_url, :wallet_balance,
             :home_duration_in_seconds, :away_duration_in_seconds, :lat, :lng
end
