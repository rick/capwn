class AddElementToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :element, :string
  end

  def self.down
    remove_column :accounts, :element
  end
end
