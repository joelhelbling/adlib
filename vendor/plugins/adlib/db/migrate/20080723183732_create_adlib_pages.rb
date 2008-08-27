class CreateAdlibPages < ActiveRecord::Migration
  def self.up
    create_table :adlib_pages do |t|
      t.string :name, :title, :layout, :slug, :url
      t.integer :shortcut_id, :section_id, :parent_id, :lft, :rgt
      t.timestamps
    end
  end

  def self.down
    drop_table :adlib_pages
  end
end