class Artist < ActiveRecord::Base
  belongs_to :genre

  has_many :albums
  has_many :tracks, through: :albums
end
