require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CategoriesController do
  it_should_behave_like 'a RESTful controller with routes'
  it_should_behave_like 'a RESTful controller'
end
