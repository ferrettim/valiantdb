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
  end

  def privacy
    @pgtitle = "Privacy Policy"
  end 

  def terms
    @pgtitle = "Terms of Use"
  end

  def userguide
    @pgtitle = "User Guide"
  end

  def changelog
    @pgtitle = "Changelog"
  end

  def top25
    @pgtitle = "Top 25 User Collections"
  end

  def supportus
    @pgtitle = "Support the Valiant Database"
  end

end
