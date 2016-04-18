require 'rss'

class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]


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

  def top25
    @pgtitle = "Top 25 Users"
    @users = User.order("(SELECT COUNT(owns.id) FROM owns WHERE user_id = users.id) DESC").limit(25)
    @counter = 0
    @hardcats = [1,5,9,18,26,28,29,36,71,121,132,148,152,170,198,230,310,492,472]
    respond_to do |format|
      format.html
    end
  end

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
    @hardcats = [1,5,9,18,26,28,29,36,71,121,132,148,152,170,198,230,310,492,472]
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.followees(User), owner_type: "User").page(params[:page]).per(10)
    @activities_site = PublicActivity::Activity.order("created_at desc").where(trackable_type: "Book").limit(10)
    @newbooks = Book.where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
    @newbooks2 = Book.where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => (Date.today.beginning_of_week + 1.week)..(Date.today.end_of_week + 1.week)).order(:title)
    @owned_last = Own.where(:user_id == @user.id).order(created_at: :asc).limit(12)
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
      accessible = [ :name, :email, :id, :avatar, :slug, :tableview, :voice, :patron, :illuminati ] # extend with your own parameters
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end