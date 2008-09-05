class RenameActiveToIsactive < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :active
    add_column :accounts, :isactive, :boolean, :default => true
  end

  def self.down
    add_column :accounts, :active, :boolean, :default => true
    remove_column :accounts, :isactive
  end
end
