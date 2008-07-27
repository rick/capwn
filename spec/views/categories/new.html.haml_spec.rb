require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'categories/new.html' do
  before :each do
    @category = Category.new
    assigns[:category] = @category
  end
  
  def do_render
    render 'categories/new.html.haml'
  end

  it 'should show any errors' do
    flash[:notice] = 'Error Message'
    do_render
    response.should have_text(/Error Message/)
  end

  it 'should not show errors if there are none' do
    flash[:notice] = nil
    do_render
    response.should_not have_tag('div[class=?]', 'error')
  end

  it 'should include a new category form' do
    do_render
    response.should have_tag('form')
  end

  describe 'new category form' do
    it 'should post to the category create action' do
      do_render
      response.should have_tag('form[method=?][action=?]', 'post', categories_path)
    end
    
    it 'should include a field for entering the category name' do
      do_render
      response.should have_tag('input[type=?][name=?]', 'text', 'category[name]')
    end
    
    it 'should include a submit button' do
      do_render
      response.should have_tag('input[type=?]', 'submit')
    end
  end
end
