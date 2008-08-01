class AddAdminFlagToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :isAdmin, :boolean, :default => 0
  end

  def self.down
    remove_column :users, :isAdmin
  end
end
