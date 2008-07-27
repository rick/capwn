require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'categories/index.html' do
  before :each do
    @categories = Array.new(5) { Category.generate! }
    assigns[:categories] = @categories
  end

  def do_render
    render 'categories/index.html.haml'
  end
  
  it 'should include a link to show details for each category' do
    do_render
    @categories.each do |category|
      response.should have_tag('a[href=?]', category_path(category))      
    end
  end
  
  it 'should have an edit link for each category' do
    do_render
    @categories.each do |category|
      response.should have_tag('a[href=?]', edit_category_path(category))      
    end
  end
    
  it 'should show the name of each category' do
    do_render
    @categories.each do |category|
      response.should have_text(Regexp.new(Regexp.escape(category.name)))
    end
  end

  it 'should have a destroy link for each category' do
    do_render
    @categories.each do |category|
      response.should have_tag('a[href=?][onclick*=?]', category_path(category), 'delete')
    end
  end

  it 'should include confirmation in each category destroy link' do
    do_render
    @categories.each do |category|
      response.should have_tag('a[href=?][onclick*=?]', category_path(category), 'confirm')
    end
  end
  
  it 'should include a link to add a new category' do
    do_render
    response.should have_tag('a[href=?]', new_category_path)
  end  
end
