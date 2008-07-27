class Category
  generator_for :name, :start => 'Category 1' do |prev|
    prev.succ
  end
end
