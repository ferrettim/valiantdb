xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.rss :version => "2.0" do
  xml.channel do
    for article in @feed_posts
      xml.item do
        if article.category == "Default"
          xml.title "Out this week " + article.title.to_s + " #" + article.issue.to_s
        elsif article.category == "Paperback"
          xml.title "Out this week " + article.title.to_s + " Volume " + article.issue.to_s + " Trade Paperback"
        elsif article.category == "Hardcover"
          xml.title "Out this week " + article.title.to_s + " Volume " + article.issue.to_s + " Deluxe Hardcover"
        end
        xml.link "https://www.valiantdatabase.com/books/" + article.slug.to_s
        xml.pubDate article.rdate.to_s + "T00:00:00.0Z"
        if article.category == "Default"
          xml.description = "Written by " + article.writer.to_s + " with art by " + article.artist.to_s + " and cover by " + article.cover.to_s + ". This book has " + Book.where(:title => article.title.to_s).where(:issue => article.issue.to_s).where(:rdate => article.rdate.to_s).where(:category => "Variant").count.to_s + " variants."
        elsif article.category == "Paperback"
          xml.description = "Written by " + article.writer.to_s + " with art by " + article.artist.to_s + " and cover by " + article.cover.to_s + "."
        elsif article.category == "Hardcover"
          xml.description = "Written by " + article.writer.to_s + " with art by " + article.artist.to_s + " and cover by " + article.cover.to_s + "."
        end
        xml.guid article.id.to_s
      end
    end
  end
end
