class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts, :force => true do |t|
      t.integer :entry_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
