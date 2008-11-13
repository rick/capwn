class RemovePaidAtFromMemo < ActiveRecord::Migration
  def self.up
    remove_column :memos, :paid_at
  end

  def self.down
    add_column :memos, :paid_at
  end
end
