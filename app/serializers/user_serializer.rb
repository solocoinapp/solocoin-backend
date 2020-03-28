class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :mobile, :profile_picture_url, :wallet_balance
end
