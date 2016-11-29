#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Valiant Database Recently Added"
    xml.author "Martin Ferretti"
    xml.description "The best Valiant Comics resource on the web"
    xml.link "https://www.valiantdatabase.com"
    xml.language "en"

    for article in @feed_posts
      xml.item do
        if article.title
          if article.category == "Paperback"
            xml.title "New to the database, " + article.title.to_s + " TPB Vol. " + article.issue.to_s
          elsif article.category == "Hardcover"
            xml.title "New to the database, " + article.title.to_s + " Deluxe HC Vol. " + article.issue.to_s
          else
            xml.title "New to the database, " + article.title.to_s + " #" + article.issue.to_s
          end
        else
          xml.title ""
        end
        xml.author article.cover.to_s
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link "http://www.valiantdatabase.com/books/" + article.id.to_s + "-" + article.title.to_s.parameterize + "-" + article.issue.to_s + "-" + article.cover.to_s.parameterize
        xml.guid article.id.to_s

        if article.category == "Sketch"
          text = "Sketch cover by " + article.cover.to_s
        else
          text = "Written by " + article.writer.to_s + ", art by " + article.artist.to_s + ". Released on " + article.rdate.to_s(:rfc822)
        end
		# if you like, do something with your content text here e.g. insert image tags.
		# Optional. I'm doing this on my website.
        unless article.image.blank?
            image_url = article.image.url(:medium)
            image_caption = "Cover by " + article.cover.to_s
            image_align = ""
            image_tag = "
                <p><img src='" + image_url +  "' alt='" + image_caption + "' title='" + image_caption + "' align='" + image_align  + "' /></p>
              "
            text = text.sub('{image}', image_tag)
        end
        xml.description text

      end
    end
  end
end
