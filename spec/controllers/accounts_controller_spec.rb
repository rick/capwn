require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController do
  it_should_behave_like 'a RESTful controller requiring login'
end

