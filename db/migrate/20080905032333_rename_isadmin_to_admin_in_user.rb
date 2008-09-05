class RenameIsadminToAdminInUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :isAdmin
    add_column :users, :admin, :boolean, :default => false
  end

  def self.down
    add_column :users, :isAdmin, :boolean, :default => false 
    remove_column :users, :admin
  end
end
