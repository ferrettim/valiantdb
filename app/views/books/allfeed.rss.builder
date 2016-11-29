#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Valiant Database New releases"
    xml.author "Martin Ferretti"
    xml.description "The best comic book resource on the web"
    xml.link "https://www.valiantdatabase.com"
    xml.language "en"

    for article in @feed_posts
      xml.item do
        xml.title "Out this week " + article.title.to_s + " #" + article.issue.to_s
        xml.link "https://www.valiantdatabase.com/books/" + article.slug.to_s
        xml.guid article.id.to_s

        if article.category == "Sketch"
          text = "Sketch cover by " + article.cover.to_s
        else
          text = "Written by " + article.writer.to_s + " with art by " + article.artist.to_s + " and cover by " + article.cover.to_s + ". This book has " + Book.where(:title => article.title.to_s).where(:issue => article.issue.to_s).where(:rdate => article.rdate.to_s).where(:category => "Variant").count.to_s + " variants."
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
