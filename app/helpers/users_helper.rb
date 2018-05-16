module UsersHelper
  def max_page_number(user, items_per_page = 5)
    if user.line_items.length % items_per_page == 0
      user.line_items.length / items_per_page
    else
      user.line_items.length / items_per_page + 1
    end
  end

  def get_pagination_index(user, item_per_page)
    if item_per_page
      (1..max_page_number(user, item_per_page))
    else
      (1..max_page_number(user))
    end
  end

  def get_param_as_integer(param_item)
    param_item.to_i if ((param_item.to_i.to_s == param_item) && param_item != '0')
  end
end
