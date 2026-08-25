module OrdersHelper
  def status_color(status)
    case status
    when "pending" then "text-yellow-400 bg-yellow-900/30"
    when "paid" then "text-green-400 bg-green-900/30"
    when "shipped" then "text-blue-400 bg-blue-900/30"
    when "delivered" then "text-green-300 bg-green-900/50"
    when "cancelled" then "text-red-400 bg-red-900/30"
    else "text-gray-400 bg-gray-900/30"
    end
  end
end
