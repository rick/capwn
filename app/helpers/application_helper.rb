# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def currencize(initialBalance)
    n = sprintf("%.2f", initialBalance)
    n.to_s =~ /([^\.]*)(\..*)?/
    int, dec = $1.reverse, $2 ? $2 : ""
    while int.gsub!(/(,|\.|^)(\d{3})(\d)/, '\1\2,\3')
    end
    int.reverse + dec
  end
end
