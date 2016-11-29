#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Valiant Database New Releases"
    xml.author "Martin Ferretti"
    xml.description "The best Valiant Comics resource on the web"
    xml.link "https://www.valiantdatabase.com"
    xml.language "en"

    for article in @feed_posts
      xml.item do
        if article.title
          if article.category == "Paperback"
            xml.title "Out this week, " + article.title.to_s + " TPB Vol. " + article.issue.to_s
          elsif article.category == "Hardcover"
            xml.title "Out this week, " + article.title.to_s + " Deluxe HC Vol. " + article.issue.to_s
          else
            xml.title "Out this week, " + article.title.to_s + " #" + article.issue.to_s
          end
        else
          xml.title ""
        end
        xml.author article.cover.to_s
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link "http://www.valiantdatabase.com/books/" + article.id.to_s + "-" + article.title.to_s.parameterize + "-" + article.issue.to_s + "-" + article.cover.to_s.parameterize
        xml.guid article.id.to_s

        if article.category == "Paperback"
          text = article.title.to_s + " Volume " + article.issue.to_s + " Trade Paperback. Written by " + article.writer.to_s + ", art by " + article.artist.to_s
        elsif article.category == "Hardcover"
          text = article.title.to_s + " Deluxe Hardcover Volume " + article.issue.to_s + ".Written by " + article.writer.to_s + ", art by " + article.artist.to_s
        elsif article.category == "Default"
          text = article.title.to_s + " #" + article.issue.to_s + ".Written by " + article.writer.to_s + ", art by " + article.artist.to_s + "This book has " + Book.where(:title => article.title.to_s).where(:issue => article.issue.to_s).where(:rdate => article.rdate.to_s).where(:category => "Variant").count.to_s + " variant covers."
        xml.description text

      end
    end
  end
end
