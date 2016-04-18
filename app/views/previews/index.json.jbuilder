json.array!(@previews) do |preview|
  json.extract! preview, :id, :description, :book_id
  json.url preview_url(preview, format: :json)
end
