class SessionSerializer < ActiveModel::Serializer
  attributes :id, :status, :session_type, :start_time, :end_time, :rewards
end
