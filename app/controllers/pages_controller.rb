require 'feedjira'

class PagesController < ApplicationController

  @optionstitle = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(title)").group("title").order("title")

  def home
  	@rdate = DateTime.now.next_day(1).strftime("%B %d, %Y")
    @newbooks = Book.where.not("note like ?", "%Sketch cover%").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(title: :asc, category: :asc)
    @book = Book.order("created_at").last(25)
    @tcount = Book.all.count
    if user_signed_in?
      redirect_to root_url + "users/" + current_user.slug + "/profile"
    end
  end

  def search
  	redirect_to root_path
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

  def veitimeline
    @pgtitle = "Valiant Timeline"
  end

  def marketshare
    @pgtitle = "Valiant Marketshare"
  end

end
