json.array!(@books) do |book|
  json.extract! book, :id, :issue, :title, :rdate, :note, :image
  json.url book_url(book, format: :json)
end
