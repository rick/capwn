require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Memo do
  describe 'object' do
    before :each do
      @memo = Memo.new
    end
    
    it 'can have a user' do
      @memo.should respond_to(:user)
    end
    
    it 'can have entries' do
      @memo.should respond_to(:entries)
    end
    
    it 'can have a text' do
      @memo.should respond_to(:text)
    end
    
  end
  
  describe 'validations' do
    before :each do
      @user = User.generate!
      @memo = Memo.generate(:user => @user)
    end
    
    it 'must have a user to be valid' do
      @memo.user = nil
      @memo.should_not be_valid
      @memo.should have(1).errors_on(:user)
    end
    
  end

  describe 'finders' do
    before :each do
      checking = Account.generate!(:name => "checking")
      income = Account.generate!(:name => "income")
      taxes = Account.generate!(:name => "taxes")
      @memo = Memo.generate!(:user => User.generate!,
                             :text => "paycheck")
      Entry.generate!(:memo => @memo,
                      :debit_account => income,
                      :credit_account => checking,
                      :amount => 500)
      Entry.generate!(:memo => @memo,
                      :debit_account => income,
                      :credit_account => taxes,
                      :amount => 500)
    end
end
  
