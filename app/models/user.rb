
class User < ApplicationRecord

  LEADERBOARD_LIMIT  = 10
  LEADERBOARD_FIELDS = [:id, :name, :profile_picture_url, :country_code, :wallet_balance]

  acts_as_mappable
  audited except: :password
  devise :database_authenticatable, :registerable, :timeoutable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Profile picture
  mount_base64_uploader :profile_picture, ProfilePictureUploader
  after_destroy :remove_profile_picture!
  validates_integrity_of  :profile_picture
  validates_processing_of :profile_picture
  validate :profile_picture_size

  # Destroying user record is not recommended at all. It will leave orphan references in bunch of places in the
  # application, especially in reporting. These dependant: :destroy callbacks added to cover the worst cases
  # Where the destroy is absolutely necessary.
  has_many :identities, dependent: :destroy
  has_many :wallet_transactions, dependent: :destroy
  has_many :notification_tokens, dependent: :destroy
  before_validation :remove_devise_validations, unless: :email_auth_validations

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, if: :email_auth_validations
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, if: :email_auth_validations
  validates :mobile, uniqueness: true, allow_blank: true
  validate :password_complexity, if: :email_auth_validations
  validate :lat_lng_unchanged
  validates_length_of :name, minimum: 3, maximum: 30

  before_create :set_identifier

  def set_identifier
    self.identifier = generate_identifier
  end

  def generate_identifier
    loop do
      identifier = 8.times.map{rand(10)}.join
      break identifier unless User.where(identifier: identifier).exists?
    end
  end

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[a-z])(?=.*?[#?!@$%^&*-]).{8,70}$/
    errors.add :password, :password_complexity_error
  end

  def wallet_withdraw_able?
    wallet_balance >= 1000
  end

  def fetch_auth_token
    return auth_token if auth_token.present?
    generate_auth_token
  end

  def save_provider_auth_user
    self.email_auth_validations = false
    skip_confirmation!
    save
  end

  def remove_devise_validations
    self.class.class_eval do
      _validators.delete(:email)
      _validators.delete(:password)

      _validate_callbacks.each do |callback|
        if callback.raw_filter.respond_to? :attributes
          callback.raw_filter.attributes.delete :email
          callback.raw_filter.attributes.delete :password
        end
      end
    end
  end

  def self.fetch_leaderboard_stats(current_user)
    # Fetches top users with maximum wallet_balance. Also appends their respective rank.
    top_users_json    = User.order('wallet_balance desc').limit(LEADERBOARD_LIMIT).as_json(only: LEADERBOARD_FIELDS)
    top_users_json.each_with_index do |user, idx|
      user['wb_rank'] = idx + 1
    end

    # Checks if current user is in top users
    # If yes, then we are done.
    # Else, finds rank of current user and build its json
    current_user_in_top_users = top_users_json.select{|user| user['id'] == current_user.id}
    if current_user_in_top_users.present?
      current_user_json = current_user_in_top_users.first
    else
      current_user_json = current_user.as_json(only: LEADERBOARD_FIELDS)
      current_user_rank = User.where('wallet_balance > ?', current_user.wallet_balance).count + 1
      current_user_json['wb_rank'] = current_user_rank
    end

    return {
        top_users: top_users_json,
        user: current_user_json
    }
  end

  private

  def generate_auth_token
    loop do
      token = Devise.friendly_token
      unless User.find_by(auth_token: token)
        update(auth_token: token)
        break
      end
    end
    self.auth_token
  end

  def profile_picture_size
    errors.add :profile_picture, :profile_picture_size_limit if profile_picture.size > 10.megabytes
  end

  def lat_lng_unchanged
    if self.persisted?
      errors.add(:lat, 'can not be updated once set!') if lat_was.present? && lat_changed?
      errors.add(:lng, 'can not be updated once set!') if lng_was.present? && lng_changed?
    end
  end

end
