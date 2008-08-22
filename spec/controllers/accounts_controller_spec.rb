require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController do
  def redirects_to_index 
    true
  end
  it_should_behave_like 'a RESTful controller requiring login'
end

