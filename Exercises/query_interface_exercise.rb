    # Build queries for following
    #Get All products which are present in atleast one line_item
    p Product.joins(:line_items).distinct

    #Get array of product titles which are present in atleast one line item
    p Product.joins(:line_items).distinct.pluck(:title)