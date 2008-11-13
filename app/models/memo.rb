class Memo < ActiveRecord::Base
  belongs_to :user
  has_many :entries
  
  validates_presence_of :paid_at, :user
end
