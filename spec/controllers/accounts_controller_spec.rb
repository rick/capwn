require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController do

  describe 'index' do
    before :each do
      get :index
    end

    it 'should find accounts' do
      assigns[:accounts].should_not be_nil
    end
    it 'should render index template' do
      response.should render_template(:index)
    end
    it 'should respond successfully' do
      response.should be_success
    end
  end
end

