class SitemapController < ApplicationController
  def index
  	@pgtitle = "Sitemap"
    @books = Book.order("created_at DESC") 

    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
end