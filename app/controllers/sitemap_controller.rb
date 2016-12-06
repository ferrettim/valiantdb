class SitemapController < ApplicationController
  def index
  	@pgtitle = "Valiant Database Sitemap"
    @books = Book.order("rdate ASC")

    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
end
