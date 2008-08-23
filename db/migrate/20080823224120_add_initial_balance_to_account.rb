class AddInitialBalanceToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :initialBalance, :decimal, :scale => 2, :precision => 15, :default => 0
  end

  def self.down
    remove_column :accounts, :initialBalance
  end
end
