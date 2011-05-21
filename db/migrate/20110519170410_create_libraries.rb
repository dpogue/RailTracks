class CreateLibraries < ActiveRecord::Migration
  def self.up
    create_table :libraries do |t|
      t.string :path
      t.boolean :recursive
      t.timestamp :scanned

      t.timestamps
    end

    change_table :songs do |t|
      t.references :library
    end
  end

  def self.down
    drop_table :libraries
    remove_column :songs, :library
  end
end
