require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Making a purchase from a cash account" do
  before :each do
    @user = User.generate!
    @cash = Account.generate!
    @groceries = Account.generate!
  end

  it 'should require a payment date'
  it 'should require a memo party'
  it 'should require a cash account entry'

  describe 'the cash account entry' do
    it 'should require the cash account'
    it 'should require an amount'
  end

  it 'should require a tagged account entry'

  describe 'the tagged account entry' do
    it 'should require the tagged account'
    it 'should require an amount'
  end

  it 'should require the memo to balance'

  it 'should succeed if all necessary information is provided' do
    @memo = Memo.create!(:text => 'test memo',
                         :paid_at => Time.now,
                         :user => @user)

    @memo.entries.create!(:debit_account   => @cash, 
                          :credit_account  => @groceries, 
                          :amount          => 24)
  end

  describe "and reconciling" do
    it "should not attempt to reconcile against the cash account"
  end
end

describe "Making a purchase from a checking account to a merchant via check card" do

  describe "and reconciling" do
    it "should be able to reconcile against the checking account entry"
  end
end

describe "Making a purchase from a checking acocunt to a merchant via check" do

  it "should allow entering a check number"

  describe "and reconciling" do
    it "should be able to reconcile against the check entry"
  end
end

describe "Making an ATM withdrawal from a checking account" do

  it "should require a checking account entry"
  it "should require a cash account entry"

  describe "and reconciling" do
    it "should be able to reconcile against the check entry"
    it "should not attempt to reconcile against the cash account entry"
  end

  describe "with ATM fees" do
    it "should allow a bank fee entry"
    it "should allow an ATM fee entry (foreign bank)"

    describe "and reconciling" do
      it "should be able to reconcile against any bank fee entry"
      it "should be able to reconcile against any ATM fee entry"
    end
  end
end

describe "Making an ATM withdrawal during a purchase from a checking account" do
  it "should require a checking account entry for the ATM withdrawal"
  it "should require a cash account entry"
  it "should require a checking account entry for the purchase"

  describe "and reconciling" do
    it "should be able to reconcile against the sum of the checking account entry and the ATM withdrawal"
    it "should be able to reconcile against any bank fee entry"
    it "should be able to reconcile against any ATM fee entry"
    it "should not attempt to reconcile against the cash account entry"
  end
end

describe "A bank charges a fee against an account" do
  describe "when reconciling" do
    it "should find no match in the account's entries"
  end
end

describe 'Paying a bill via online bill payment' do
  it 'should allow entering an entry date'
  it 'should allow entering a payment date'

  describe 'and reconciling' do
    it 'should reconcile against the payment memo'
  end
end
