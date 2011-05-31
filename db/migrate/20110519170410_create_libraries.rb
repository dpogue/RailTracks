class CreateLibraries < ActiveRecord::Migration
  def self.up
    create_table :libraries do |t|
      t.string :path
      t.boolean :recursive
      t.timestamp :scanned

      t.timestamps
    end

    add_index :libraries, :path, :unique => true
  end

  def self.down
    drop_table :libraries
  end
end
