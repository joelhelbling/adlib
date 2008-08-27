class CreateAdlibUsers < ActiveRecord::Migration
  def self.up
    create_table :adlib_users do |t|
      t.string :username, :password_hash, :password_salt
      t.timestamps
    end
  end

  def self.down
    drop_table :adlib_users
  end
end