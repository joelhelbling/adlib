class CreateAdlibImages < ActiveRecord::Migration
  def self.up
    create_table :adlib_images do |t|
      t.integer :page_id
      t.string :slot, :content_type, :filename, :content_hash
      t.integer :size, :width, :height, :default => 0
      t.binary :content, :limit => (2**31 - 1)
      t.timestamps
    end
  end

  def self.down
    drop_table :adlib_images
  end
end