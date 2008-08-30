class AddActiveToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :active, :boolean, :default => 1
  end

  def self.down
    remove_column :accounts, :active
  end
end
