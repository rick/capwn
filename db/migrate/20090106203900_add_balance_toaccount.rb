class AddBalanceToaccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :balance, :decimal, :scale => 2, :precision => 15, :default => 0
  end

  def self.down
    remove_column :accounts, :balance
  end
end
