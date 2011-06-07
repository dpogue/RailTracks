class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  belongs_to :library

  def as_json(options)
    {
      :id => self.id,
      :title => self.title,
      :artist => self.artist.name,
      :album => (self.album.nil? ? '' : self.album.name),
      :track => self.track
    }
  end
end
