require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'categories/show.html' do
  before :each do
    @category = Category.generate!
    assigns[:category] = @category
  end

  def do_render
    render 'categories/show.html.haml'
  end
  
  it 'should show the category name' do
    do_render
    response.should have_text(Regexp.new(Regexp.escape(@category.name)))
  end
  
  it 'should include a link to edit this category' do
    do_render
    response.should have_tag('a[href=?]', edit_category_path(@category))
  end
end
