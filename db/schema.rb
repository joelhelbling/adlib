# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080723183734) do

  create_table "adlib_images", :force => true do |t|
    t.integer  "page_id",      :limit => 11
    t.string   "slot"
    t.string   "content_type"
    t.string   "filename"
    t.string   "content_hash"
    t.integer  "size",         :limit => 11,         :default => 0
    t.integer  "width",        :limit => 11,         :default => 0
    t.integer  "height",       :limit => 11,         :default => 0
    t.binary   "content",      :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adlib_pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "layout"
    t.string   "slug"
    t.string   "url"
    t.integer  "shortcut_id", :limit => 11
    t.integer  "section_id",  :limit => 11
    t.integer  "parent_id",   :limit => 11
    t.integer  "lft",         :limit => 11
    t.integer  "rgt",         :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adlib_sections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adlib_snippets", :force => true do |t|
    t.integer  "page_id",    :limit => 11
    t.string   "slot"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adlib_users", :force => true do |t|
    t.string   "username"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
