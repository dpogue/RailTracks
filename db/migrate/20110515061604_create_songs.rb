class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :title
      t.string :file
      t.integer :track
      t.float :length
      t.references :artist
      t.references :album
      t.references :library
    end

    add_index :songs, :artist_id
    add_index :songs, :album_id
    add_index :songs, :file, :unique => true
  end

  def self.down
    drop_table :songs
  end
end
