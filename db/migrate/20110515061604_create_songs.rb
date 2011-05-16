class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :title
      t.string :file
      t.integer :track
      t.references :artist
      t.references :album
    end

    add_index :songs, :artist_id, :name => 'artist_id_ix'
    add_index :songs, :album_id, :name => 'album_id_ix'
    add_index :songs, :file, :name => 'filename_ix'
  end

  def self.down
    drop_table :songs
  end
end
