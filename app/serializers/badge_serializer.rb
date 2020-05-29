class BadgeSerializer < ApplicationSerializer
  attributes :level, :name, :one_liner, :badge_image_url, :min_points

  def badge_image_url
    object.badge_image.url
  end
end
