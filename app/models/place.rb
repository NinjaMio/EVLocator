class Place < ApplicationRecord
  belongs_to :project
  belongs_to :user
  validates :placename, presence: true
  validates :address, presence: true
  validates :project_id, presence: true

  geocoded_by :address
  after_validation :geocode
end
