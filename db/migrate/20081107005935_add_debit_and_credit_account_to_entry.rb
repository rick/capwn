class AddDebitAndCreditAccountToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :debit_account_id, :integer
    add_column :entries, :credit_account_id, :integer
    remove_column :entries, :account_id
  end

  def self.down
    remove_column :entries, :credit_account_id
    remove_column :entries, :debit_account_id
    add_column :entries, :account_id, :integer
  end
end
