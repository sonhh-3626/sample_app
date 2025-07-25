class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: Settings.IMAGE_RESIZE_TO_LIMIT_500_500
  end

  validates :user_id, presence: true
  validates :content, presence: true,
        length: {maximum: Settings.MAX_LENGTH_MICROPOST_CONTENT_140}
  validates :image, content_type:
        {
          in: %w(image/jpeg image/gif image/png),
          message: I18n.t("microposts.validations.image_invalid_format")
        },
        size: {
          less_than: Settings.IMAGE_SIZE_LARGE_LIMIT_5.megabytes
        }

  MICROPOST_PARAMS = %w(content image).freeze

  scope :order_by_latest, ->{order(created_at: :desc)}
end
