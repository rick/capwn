require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do
  before(:each) do
    @category = Category.new
  end
  
  describe 'when validating' do
    it 'should not be valid without a name' do
      @category.should_not be_valid
      @category.should have(1).errors_on(:name)
    end
    
    it 'should be valid if it has a name' do
      Category.new(:name => 'foo').should be_valid
    end
    
    it 'should require names to be unique' do
      category = Category.generate!
      dup = Category.new(:name => category.name)
      dup.should_not be_valid
      dup.should have(1).errors_on(:name)
    end
  end
  
  describe 'attributes' do
    it 'should have a name' do
      @category.name.should be_nil
    end
    
    it 'can be budgeted' do
      @category.should_not be_budgeted
    end
  end
end
