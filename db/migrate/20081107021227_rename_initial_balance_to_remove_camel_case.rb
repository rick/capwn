class RenameInitialBalanceToRemoveCamelCase < ActiveRecord::Migration
  def self.up
    rename_column :accounts, :initialBalance, :initial_balance
  end

  def self.down
    rename_column :accounts, :initial_balance, :initialBalance
  end
end
