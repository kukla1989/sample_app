class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validates :image, content_type: {in: %w[image/jpeg image/png image/gif],
                                   message: "should be png, jpeg or gif type"},
                    size:         {less_than: 5.megabytes,
                                   message: "image should be less then 5 megabytes"}
end
