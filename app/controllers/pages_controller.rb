require 'feedjira'

class PagesController < ApplicationController

  def home
  	@rdate = DateTime.now.next_day(1).strftime("%B %d, %Y")
    @newbooks = Book.where.not("note like ?", "%Sketch cover%").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
    @book = Book.order("created_at").last(25)
    @tcount = Book.all.count
    if user_signed_in?
      redirect_to root_url + "users/" + current_user.slug + "/profile"
    end
  end

  def search
  	@pgtitle = "Search"
    @search_count = Book.search(params[:query]).count
    @title = Book.search(params[:query], page: params[:page], per_page: 24)
    @tcount = Book.all.count
  end

  def privacy
    @pgtitle = "Comicark Privacy Policy"
  end 

  def terms
    @pgtitle = "Comicark Terms of Use"
  end

  def changelog
    @pgtitle = "Comicark Changelog"
  end

  def top25
    @pgtitle = "Comicark Top 25 User Collections"
  end

  def supportus
    @pgtitle = "Support the Comicark"
  end

  def levels
    @pgtitle = "Comicark User Levels"
  end

  def chat
    @pgtitle = "Comicark Chat"
  end

end
