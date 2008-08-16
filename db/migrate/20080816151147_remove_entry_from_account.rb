class RemoveEntryFromAccount < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :entry_id
  end

  def self.down
    add_column :users, :entry_id, :integer
  end
end
