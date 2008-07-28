class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions, :force => true do |t|
      t.string :memo
      t.integer :user_id
      t.datetime :paid_at
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
