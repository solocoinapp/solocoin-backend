class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :mobile, :profile_picture_url, :wallet_balance,
             :home_duration_in_seconds, :lat, :lng

  def home_duration_in_seconds
    active_session = object.active_session
    if active_session.present? && active_session.home?
      object.home_duration_in_seconds + active_session.in_seconds
    else
      object.home_duration_in_seconds
    end
  end
end
