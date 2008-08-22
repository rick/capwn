require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'layouts/application.html' do
  def do_render
    render 'layouts/application.html.haml'
  end

  it 'should have a link to access accounts' do
    do_render
    response.should have_tag('a[href=?]', accounts_path)
  end
end
