class Project < ApplicationRecord
  mount_uploader :picture, PictureUploader
  validates :name, presence: true
  validates :picture, presence: true

  belongs_to :user
  has_many :places, dependent: :delete_all
end
