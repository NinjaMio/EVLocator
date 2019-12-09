class Project < ApplicationRecord
  mount_uploader :picture, PictureUploader
  validates :name, presence: true

  belongs_to :user
  has_many :places
end
