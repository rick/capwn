class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries, :force => true do |t|
      t.decimal :amount, :scale => 2, :precision => 11
      t.integer :account_id, :transaction_id
      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
