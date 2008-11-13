class RenameTransactionToMemo < ActiveRecord::Migration
  def self.up
    rename_table  :transactions,  :memos
    rename_column :memos,         :memo,            :text
    rename_column :entries,       :transaction_id,  :memo_id
  end

  def self.down
    rename_table  :memos,         :transactions
    rename_column :transactions,  :text,            :memo 
    rename_column :entries,       :memo_id,         :transaction_id
  end
end
