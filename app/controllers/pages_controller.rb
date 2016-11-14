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
    @pgtitle = "Valiant Database Privacy Policy"
  end

  def terms
    @pgtitle = "Valiant Database Terms of Use"
  end

  def changelog
    @pgtitle = "Valiant Database Changelog"
  end

  def top25
    @pgtitle = "Valiant Database Top 25 User Collections"
  end

  def supportus
    @pgtitle = "Support the Valiant Database"
  end

  def levels
    @pgtitle = "Valiant Database User Levels"
  end

end
