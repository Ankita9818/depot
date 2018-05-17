module PaginationHelper
  def max_page_number(items_per_page)
    (current_user.line_items.length.to_f / items_per_page).ceil
  end
end
