
class User < ApplicationRecord

  LEADER_BOARD_LIMIT = 10

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

  def self.fetch_leader_board_stats(current_user)
    @current_user_name   = current_user.name
    @leader_board_limit  = LEADER_BOARD_LIMIT
    sql = <<-SQL
        WITH leader_board AS (SELECT name, country_code, wallet_balance, RANK() OVER (ORDER BY wallet_balance DESC) AS wb_rank FROM users)
        (
          SELECT name, country_code, wb_rank, wallet_balance
          FROM leader_board
          LIMIT '#{@leader_board_limit}'
        )
        UNION ALL
        (
          SELECT name, country_code, wb_rank, wallet_balance
          FROM leader_board
          WHERE name = '#{@current_user_name}'
        )
    SQL

    res = User.connection.execute(sql)
    return res.as_json
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
