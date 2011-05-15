class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :title
      t.string :file
      t.integer :track
      t.references :artist
      t.references :album
    end
  end

  def self.down
    drop_table :songs
  end
end
