class Genre < ActiveRecord::Base
  has_many :artists
  has_many :albums, through: :artists
  has_many :tracks, through: :albums
end
