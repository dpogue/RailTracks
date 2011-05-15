class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :name
      t.integer :year
      t.references :artist
    end
  end

  def self.down
    drop_table :albums
  end
end
