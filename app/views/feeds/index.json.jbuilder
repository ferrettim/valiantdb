json.array!(@feeds) do |feed|
  json.extract! feed, :id, :name, :url, :summary, :image_url
  json.url feed_url(feed, format: :json)
end
