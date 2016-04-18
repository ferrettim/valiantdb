xml.instruct!

xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
  xml.url do
    xml.loc root_url
    xml.changefreq("hourly")
    xml.priority "1.0"
  end
  @books.each do |book|  
    xml.url do
      xml.loc book_url(book)
      xml.changefreq("daily")
      xml.priority "0.8"
      xml.lastmod book.updated_at.strftime("%Y-%m-%dT%H:%M:%S.%2N%:z")
    end
  end
end