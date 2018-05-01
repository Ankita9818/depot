json.extract! category, :id, :name, :parent_category_id, :created_at, :updated_at
json.url category_url(category, format: :json)
