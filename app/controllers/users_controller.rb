require 'rss'

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json, :js


  def admin
    @pgtitle = "Admin Panel"
    @users = User.all
    @books = Book.all
    respond_to do |format|
      format.html
      format.js
    end
  end

  def emails
    @users = User.all
  end

  def all
    @pgtitle = "User Listing"
    @users = User.all.order(current_sign_in_at: :desc).page(params[:page]).per(24)
    @userall = User.select(:email).map(&:email)
    @tcount = User.all.count
    @hardcats = [1,5,9,18,26,28,29,36,71,121,132,148,152,170,198,230,310,492,472]
    respond_to do |format|
      format.html
      if current_user.super_admin?
        format.csv { send_data @userall.to_csv, filename: "usersemails.csv" }
      end
    end
  end

  def leaderboard
    @pgtitle = "Leaderboard"
    @users = User.all.order('score desc').limit(75)
    @counter = 0
    @hardcats = [1,5,9,18,26,28,29,36,71,121,132,148,152,170,198,230,310,492,472]
    respond_to do |format|
      format.html
    end
  end

  def valianttop25
    @pgtitle = "Top 25 Collections"
    @users = User.all.order('owns_count desc').limit(25)
    @counter = 0
    @hardcats = [1,5,9,18,26,28,29,36,71,121,132,148,152,170,198,230,310,492,472]
    respond_to do |format|
      format.html
    end
  end

#  def valianttop25
#    @pgtitle = "Top 25 Valiant Collections"
#    book_ids = Book.where(:publisher => "Valiant Entertainment").pluck(:id)
#    count = book_ids.count
#    users_ids = Own.where(book_id: book_ids).group(:user_id).order("count(*) DESC").limit(25).pluck("user_id")
#    @users = User.where(:id => users_ids).order('owns_count desc')
#    @counter = 0
#    @hardcats = [1,5,9,18,26,28,29,36,71,121,132,148,152,170,198,230,310,492,472]
#    respond_to do |format|
#      format.html
#    end
#  end

  def backers
    @pgtitle = "Thank you Patreon backers!"
    @bosses = User.where(:patron => true).where(:level50 => true).order(name: :asc)
    @sponsors = User.where(:patron => true).where(:level20 => true).order(name: :asc)
    @producers = User.where(:patron => true, :level5 => true, :level20 => nil).order(name: :asc)
    @users = User.where(:patron => true, :level5 => nil, :level20 => nil).order(name: :asc).page(params[:page]).per(100)
    @counter = 0
    @hardcats = [1,5,9,18,26,28,29,36,71,121,132,148,152,170,198,230,310,492,472]
    respond_to do |format|
      format.html
    end
  end

  def follow
    @user = User.friendly.find(params[:user])
    current_user.follow!(@user)
  end

  def unfollow
    @user = User.friendly.find(params[:user])
    current_user.unfollow!(@user)
  end

  # GET /users/:id.:formatBook.find(a.trackable_id)
  def show
    @user = User.friendly.find(params[:id])
    if user_signed_in? && current_user == @user
      @pgtitle = "My Dashboard"
    else
      @pgtitle = "#{@user.name}'s Dashboard"
    end
    @pollnew = Poll.last
    @pollold = Poll.order(created_at: :desc).offset(1).first
    @hotbooks = Book.where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week)
    @hardcats = [1,5,9,18,26,28,29,36,71,121,132,148,152,170,198,230,310,492,472]
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.followees(User), owner_type: "User").page(params[:page]).per(10)
    @activities_site = PublicActivity::Activity.order("created_at desc").where(trackable_type: "Book").limit(10)
    @newbooks = Book.where(:publisher => "Valiant Entertainment").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(title: :asc, category: :asc, ratio: :desc)
    @newbooks2 = Book.where(:publisher => "Valiant Entertainment").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => (Date.today.beginning_of_week + 1.week)..(Date.today.end_of_week + 1.week)).order(title: :asc, category: :asc, ratio: :desc)
    @owned_last = Own.where(:user_id == @user.id).order(created_at: :asc).limit(12)

    @filter = Book.all.where(:publisher => "Valiant Entertainment").where.not(:category => "Sketch").pub_order.page(params[:page]).per(24)
    @filter = @filter.where(:issue => params[:issue]) if params[:issue].present?
    @filter = @filter.where(:title => params[:title]) if params[:title].present?
    @filter = @filter.where(:category => params[:category]) if params[:category].present?
    @filter = @filter.where(:ratio => params[:ratio]) if params[:ratio].present?
    @filter = @filter.where(:retailer => params[:retailer]) if params[:retailer].present?
    @filter = @filter.where(:convention => params[:convention]) if params[:convention].present?
    @filter = @filter.where(:writer => params[:writer]) if params[:writer].present?
    @filter = @filter.where(:artist => params[:artist]) if params[:artist].present?
    @filter = @filter.where(:cover => params[:cover]) if params[:cover].present?
    @filtertitle = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(title)").group("title").order("title")
    @filterissue = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @filtercategory = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(category)").group("category").order("category")
    @filterratio = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(ratio)").group("ratio").order("ratio desc")
    @filterretailer = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(retailer)").group("retailer").order("retailer desc")
    @filterconvention = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(convention)").group("convention").order("convention desc")
    @filterwriter = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(writer)").group("writer").order("writer asc")
    @filterartist = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(artist)").group("artist").order("artist asc")
    @filtercover = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(cover)").group("cover").order("cover asc")
    respond_to do |format|
        format.html # show.html.erb
        format.xml { render :xml => @user }
        format.js
    end
  end

  def followers
    @user = User.friendly.find(params[:id])
    @pgtitle = "#{@user.name}'s Followers"
    @followers = @user.followers(User)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def following
    @user = User.friendly.find(params[:id])
    @pgtitle = "Following #{@user.name}'s"
    @following = @user.followees(User)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
  end

  def destroy
    @user = User.friendly.find(params[:id])
    @user.destroy
    if @user.destroy
        redirect_to root_url, notice: "User deleted."
    end
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to (root_url + "users/" + current_user.slug.to_s + "/profile"), notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def crop
    @user = User.friendly.find(params[:id])
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to root_url + "users/" + current_user.id.to_s + "/profile", notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  private
    def set_user
      @user = User.friendly.find(params[:id])
    end

    def user_params
      accessible = [ :name, :email, :id, :avatar, :slug, :tableview, :readerview, :voice, :patron, :illuminati, :level_id, :score, :pubfourfiveone, :pubaftershock, :pubarchie, :pubaspen, :pubavatar, :pubblackmask, :pubboom, :pubdarkhorse, :pubdc, :pubdynamite, :pubidw, :pubimage, :pubmarvel, :pubvaliant, :pubvertigo, :pubzenescope ] # extend with your own parameters
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
