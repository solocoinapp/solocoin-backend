class Badge < ApplicationRecord
  mount_uploader :badge_image, BadgeImageUploader
end
