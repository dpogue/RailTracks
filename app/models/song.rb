class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  belongs_to :library
end
