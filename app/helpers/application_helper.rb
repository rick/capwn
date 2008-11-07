# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def currencize(initial_balance)
    n = sprintf("%.2f", initial_balance)
    n.to_s =~ /([^\.]*)(\..*)?/
    int, dec = $1.reverse, $2 ? $2 : ""
    while int.gsub!(/(,|\.|^)(\d{3})(\d)/, '\1\2,\3')
    end
    int.reverse + dec
  end
end
