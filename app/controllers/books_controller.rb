  require 'barby'
  require 'barby/barcode/bookland'
  require 'barby/outputter/html_outputter'
  require 'digest'

class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_filter :csvauthenticate
  before_filter :authenticate, :only => :alladmin
  autocomplete :book, :title
  autocomplete :book, :writer
  autocomplete :book, :writer2
  autocomplete :book, :artist
  autocomplete :book, :artist2
  autocomplete :book, :colors
  autocomplete :book, :cover
  autocomplete :book, :letters
  autocomplete :book, :editor
  autocomplete :book, :eic
  autocomplete :book, :country
  autocomplete :book, :publisher
  respond_to :html, :json, :js

  def autocomplete
    render json: Book.search(params[:query], {
      fields: ["title^5", "writer"],
      limit: 10,
      load: false,
      misspellings: {below: 5}
    }).map(&:title)
  end

  def manage
    @drafts = Book.all.where(:status => "Pending")
  end

  def feed
    @feed_posts = Book.all.order(created_at: :desc).limit(10)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def index
    redirect_to root_path
  end

  def mywishlist
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Wishlist"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Wishlist"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Wishlist"
    end
      if params[:query].present?
        @book = @user.wished_books.where(:title => params[:query]).page(params[:page]).per(24)
      else
        @book = @user.wished_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @notowned = Book.where.not(Wish.where("wishes.book_id = books.id", "wishes.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
        @bookvei = @user.wished_books.where(:era => "VEI")
        @bookvh1 = @user.wished_books.where(:era => "VH1")
        @bookvh2 = @user.wished_books.where(:era => "VH2")
      end
      @bookcsv = @user.wished_books.order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "valiantwishlist-#{Date.today}.csv" }
      end
  end

  def mywishlisttbl
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Wishlist"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Wishlist"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Wishlist"
    end
      if params[:query].present?
        @book = @user.wished_books.where(:title => params[:query]).page(params[:page]).per(24)
      else
        @book = @user.wished_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:era => "VEI")
        @bookvh1 = @user.wished_books.where(:era => "VH1")
        @bookvh2 = @user.wished_books.where(:era => "VH2")
      end
    @bookcsv = @user.wished_books.order(title: :asc, rdate: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.csv { send_data @bookcsv.to_csv, filename: "valiantwishlist-#{Date.today}.csv" }
    end
  end

  def mywishlistvei
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Wishlist"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Wishlist"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Wishlist"
    end
      if params[:query].present?
        @book = @user.wished_books.where(:title => params[:query]).where(:era => "VEI").page(params[:page]).per(24)
      else
        @book = @user.wished_books.where(:era => "VEI").order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:era => "VEI")
        @bookvh1 = @user.wished_books.where(:era => "VH1")
        @bookvh2 = @user.wished_books.where(:era => "VH2")
      end
      @bookcsv = @user.wished_books.where(:era => "VEI").order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "current-valiantwishlist-#{Date.today}.csv" }
      end
  end

  def mywishlistvh1
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Wishlist"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Wishlist"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Wishlist"
    end
      if params[:query].present?
        @book = @user.wished_books.where(:title => params[:query]).where(:era => "VH1").page(params[:page]).per(24)
      else
        @book = @user.wished_books.where(:era => "VH1").order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:era => "VEI")
        @bookvh1 = @user.wished_books.where(:era => "VH1")
        @bookvh2 = @user.wished_books.where(:era => "VH2")
      end
      @bookcsv = @user.wished_books.where(:era => "VH1").order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "classic-valiantwishlist-#{Date.today}.csv" }
      end
  end

  def mywishlistvh2
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Wishlist"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Wishlist"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Wishlist"
    end
      if params[:query].present?
        @book = @user.wished_books.where(:title => params[:query]).where(:era => "VH2").page(params[:page]).per(24)
      else
        @book = @user.wished_books.where(:era => "VH2").order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:era => "VEI")
        @bookvh1 = @user.wished_books.where(:era => "VH1")
        @bookvh2 = @user.wished_books.where(:era => "VH2")
      end
      @bookcsv = @user.wished_books.where(:era => "VH2").order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "acclaim-wishlist-#{Date.today}.csv" }
      end
  end 

  def forsale
    @pgtitle = "My books for sale"
      @user = User.friendly.find(params[:id])
      if params[:query].present?
        @book = @user.forsale_books.where(:title => params[:query]).page(params[:page]).per(24)
      else
        @book = @user.forsale_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
      end
      @bookcsv = @user.forsale_books.order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "valiantforsale-#{Date.today}.csv" }
      end
  end

  def mywishlisttbl
    @pgtitle = "My books for sale"
    if params[:query].present?
      @search_count = Book.search(params[:query]).count
      @book = Book.search(params[:query], page: params[:page], per: 24)
    else
      @book = current_user.forsale_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
    end
  end

  def values
    @pgtitle = "Valiant Books Ranked By Value"
    @book = Book.where.not(:category => "Sketch").where.not(:category => "Paperback").where.not(:category => "Hardcover").where("pricenm > ?", "0").order(pricenm: :desc).page(params[:page]).per(24)
  end 

  def topvalues
    @pgtitle = "Top Valiant Comics Books By Value"
  end

  def salesvei
    @pgtitle = "Valiant Comics Sales by issue"
    @book = Book.all.where(:era => "VEI").where("printrun > ?", "1").order(printrun: :desc).page(params[:page]).per(24)
    @bookcsv = Book.all.where(:era => "VEI").where("printrun > ?", "1").order(printrun: :desc).limit(100)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.csv { send_data @bookcsv.to_csv, filename: "printruns-vei-#{DateTime.now}.csv" }
    end
  end

  def salestitle
    @pgtitle = "Valiant Comics Sales by title"
    @book = Book.where(:category => "Default").where(:rdate => (Date.today - 12.month)..(Date.today)).where("printrun > ?", "1").select("DISTINCT(title)").group("title").order("title")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.csv { send_data @bookcsv.super_csv, filename: "printruns-vei-#{DateTime.now}.csv" }
    end
  end

  def salesstats
    @pgtitle = "Valiant Comics Sales Statistics"
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def salesstatstitle
    @pgtitle = "Valiant Comics Title Sales"
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def topselling
    @pgtitle = "Valiant Comics Top Selling Books"
    respond_to do |format|
      format.html
      format.json { render json: @books }
      format.js
    end
  end

  def thisweek
    @skip_footer = true
    @newbooks = Book.where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).where.not(:category => "Sketch").order(:title).limit(15)
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
    end
  end

  def currentweek
    @pgtitle = "Valiant Comics Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
    @newbooks = Book.where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
    end
  end

  def nextweek
    @pgtitle = "Valant Comics Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
    @newbooks = Book.where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => (Date.today.beginning_of_week + 1.week)..(Date.today.end_of_week + 1.week)).order(:title)
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
    end
  end

  def lastmonth
    @pgtitle = "Valiant Comics Releases for " + (DateTime.now - 1.month).strftime("%B %Y")
    @newbooks = Book.where.not(:category => "Sketch").where(:rdate => (Date.today - 1.month).beginning_of_month..(Date.today - 1.month).end_of_month).order(:rdate, :title)
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
      format.csv { send_data @newbooks.to_csv, filename: "valiantreleases-#{(DateTime.now - 1.month).strftime("%B-%Y")}.csv" }
    end
  end

  def thismonth
    @pgtitle = "Valiant Comics Releases for " + DateTime.now.strftime("%B %Y")
    @newbooks = Book.where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_month..Date.today.end_of_month).order(:rdate, :title)
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
      format.csv { send_data @newbooks.to_csv, filename: "valiantreleases-#{DateTime.now.strftime("%B-%Y")}.csv" }
    end
  end

  def nextmonth
    @pgtitle = "Valiant Comics Releases for " + (DateTime.now + 1.month).strftime("%B %Y")
    @newbooks = Book.where.not(:category => "Sketch").where(:rdate => (Date.today + 1.month).beginning_of_month..(Date.today + 1.month).end_of_month).order(:rdate, :title)
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
      format.csv { send_data @newbooks.to_csv, filename: "valiantreleases-#{(DateTime.now + 1.month).strftime("%B-%Y")}.csv" }
    end
  end

  def monthafter
    @pgtitle = "Valiant Comics Releases for " + (DateTime.now + 2.month).strftime("%B %Y")
    @newbooks = Book.where.not(:category => "Sketch").where(:rdate => (Date.today + 2.month).beginning_of_month..(Date.today + 2.month).end_of_month).order(:rdate, :title)
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
      format.csv { send_data @newbooks.to_csv, filename: "valiantreleases-#{(DateTime.now + 2.month).strftime("%B-%Y")}.csv" }
    end
  end

  def latestsolicits
    @pgtitle = "Valiant Comics Releases for " + (DateTime.now + 3.month).strftime("%B %Y")
    @newbooks = Book.where.not(:category => "Sketch").where(:rdate => (Date.today + 3.month).beginning_of_month..(Date.today + 3.month).end_of_month).order(:rdate, :title)
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
      format.csv { send_data @newbooks.to_csv, filename: "valiantreleases-#{(DateTime.now + 3.month).strftime("%B-%Y")}.csv" }
    end
  end

  def vh1releasedate
    @pgtitle = "Classic Valiant by release date"
    @book = Book.where.not(:category => "Sketch").where.not(:era => "Nintendo").where.not(:era => "Wrestling").where("rdate > ?", "1991-04-30").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, title: :desc).page(params[:page]).per(24)
    @bookcsv = Book.where.not(:category => "Sketch").where.not(:era => "Nintendo").where.not(:era => "Wrestling").where("rdate > ?", "1991-04-30").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, title: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.to_csv, filename: "classicvaliant-releases-bydate.csv" }
    end
  end

  def vh1releasedatetbl
    @pgtitle = "Classic Valiant by release date"
    @book = Book.where.not(:category => "Sketch").where.not(:era => "Nintendo").where.not(:era => "Wrestling").where("rdate > ?", "1991-04-30").where("rdate < ?", "1996-09-30").order(rdate: :asc, title: :desc).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2releasedate
    @pgtitle = "Acclaim by release date"
    @book = Book.where.not(:category => "Sketch").where.not(:era => "Armada").where.not(:era => "Crime").where.not(:era => "Windjammer").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").order(rdate: :asc, title: :desc).page(params[:page]).per(24)
    @bookcsv = Book.where.not(:category => "Sketch").where.not(:era => "Armada").where.not(:era => "Crime").where.not(:era => "Windjammer").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").order(rdate: :asc, title: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.to_csv, filename: "acclaim-releases-bydate.csv" }
    end
  end

  def vh2releasedatetbl
    @pgtitle = "Acclaim by release date"
    @book = Book.where.not(:category => "Sketch").where.not(:era => "Armada").where.not(:era => "Crime").where.not(:era => "Windjammer").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").order(rdate: :asc, title: :desc).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def releasedate
    @pgtitle = "Current Valiant by release date"
    @book = Book.where.not(:category => "Sketch").where("note like ?", "%Regular edition").where("rdate > ?", "2012-05-01").order(rdate: :asc, title: :desc).page(params[:page]).per(24)
    @bookcsv = Book.where.not(:category => "Sketch").where("note like ?", "%Regular edition").where("rdate > ?", "2012-05-01").order(rdate: :asc, title: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.to_csv, filename: "vei-releases-bydate.csv" }
    end
  end

  def releasedatetbl
    @pgtitle = "Current Valiant by release date"
    @book = Book.where.not(:category => "Sketch").where("note like ?", "%Regular edition%").where("rdate > ?", "2012-05-01").order(rdate: :asc, title: :desc).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def pubvei
    @pgtitle = "Vailant Comics Timeline (2012-)"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def pubvh1
    @pgtitle = "Valiant Comics Timeline (1991-1996)"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def timelinevh1
    @pgtitle = "Valiant Comics Timeline (Classic Valiant)"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    if @book.category == "Paperback"
      @pgtitle = @book.title + " Vol. " + @book.issue.to_s + " TPB"
    elsif @book.category == "Hardcover"
      @pgtitle = @book.title + " Vol. " + @book.issue.to_s + " Deluxe HC"
    else
      @pgtitle = @book.title.to_s + " #" + @book.issue.to_s + ", cover by " + @book.cover
    end
    @sellers2 = Sale.where(:book_id => @book.id).pluck(:user_id).flatten.join(',')
    @sales_count = Sale.where(:book_id => @book.id).count
    @ownusers = User.joins(:owns).where("owns.book_id = ?", @book.id).order(last_sign_in_at: :desc)
    @wishusers = User.joins(:wishes).where("wishes.book_id = ?", @book.id).order(last_sign_in_at: :desc)
    @allusers = User.joins(:sales).where("sales.book_id = ?", @book.id).order(last_sign_in_at: :desc)
    @wishers = Wish.where(:book_id => @book.id).pluck(:user_id)
    @owners = Own.where(:book_id => @book.id).pluck(:user_id)
    @default = (Book.where(:title => @book.title).where(:issue => @book.issue).where(:category => "Default").where(rdate: (@book.rdate - 5.month)..(@book.rdate + 1.month)).where.not(:id => @book.id))
    @regular = (Book.where(:title => @book.title).where(:issue => @book.issue).where.not("note like ?", "%variant%").where.not(:id => @book.id))
    @rescues = Own.where(book_id: @book.id)
    if user_signed_in?
      @comment_count = @book.comments.where(:user_id => current_user.id).count
    end
    respond_to do |format|
      format.html
      format.json { render :json => @book }
      format.js
    end
  end

  def new
    @book = Book.new
    respond_with(@book)
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    @book.save
    save_previews(params[:previews])
    respond_with(@book)
  end

  # def update
  #  @book.update(book_params)
  #  respond_with(@book)
  # end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes!(book_params)
      compare_previews(params[:previews])
      respond_to do |format|
        format.html { redirect_to( @book )}
        format.json { render :json => @book }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :action  => :edit } # edit.html.erb
        format.json { render :nothing =>  true }
        format.js
      end
    end
  end

  def destroy
    @book.destroy
    respond_with(@book)
  end

  def mynotes
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Book Notes"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Book Notes"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Book Notes"
    end
      @book = Comment.where(user_id: @user.id).order(created_at: :desc).page(params[:page]).per(20)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
      end
  end

  def mybooks
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Collection"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Collection"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Collection"
    end
      if params[:query].present?
        @book = @user.owned_books.where(:title => params[:query]).page(params[:page]).per(24)
      else
        @book = @user.owned_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
        @bookvei = @user.owned_books.where(:era => "VEI")
        @bookvh1 = @user.owned_books.where(:era => "VH1")
        @bookvh2 = @user.owned_books.where(:era => "VH2")
      end
      @bookcsv = @user.owned_books.order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "valiantcollection-#{Date.today}.csv" }
      end
  end

  def missingbooks
    @pgtitle = "My Missing Books"
      @user = User.friendly.find(params[:id])
      if params[:query].present?
        @book = Book.where.not(Own.where("owns.book_id = books.id").limit(1).arel.exists).page(params[:page]).per(24)
      else
        @book = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
        @bookvei = Book.where.not(Own.where("owns.book_id = books.id").limit(1).arel.exists).where(:era => "VEI")
        @bookvh1 = Book.where.not(Own.where("owns.book_id = books.id").limit(1).arel.exists).where(:era => "VH1")
        @bookvh2 = Book.where.not(Own.where("owns.book_id = books.id").limit(1).arel.exists).where(:era => "VH2")
      end
      @bookcsv = Book.where.not(Own.where("owns.book_id = books.id").limit(1).arel.exists).order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "valiantcollection-#{Date.today}.csv" }
      end
  end

  def mybookstbl
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Collection"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Collection"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Collection"
    end
      if params[:query].present?
        @book = @user.owned_books.where(:title => params[:query]).page(params[:page]).per(24)
      else
        @book = @user.owned_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:era => "VEI")
        @bookvh1 = @user.owned_books.where(:era => "VH1")
        @bookvh2 = @user.owned_books.where(:era => "VH2")
      end
    @bookcsv = @user.owned_books.order(title: :asc, rdate: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.csv { send_data @bookcsv.to_csv, filename: "valiantcollection-#{Date.today}.csv" }
    end
  end

  def mybooksvei
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Collection"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Collection"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Collection"
    end
      if params[:query].present?
        @book = @user.owned_books.where(:title => params[:query]).where(:era => "VEI").page(params[:page]).per(24)
      else
        @book = @user.owned_books.where(:era => "VEI").order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:era => "VEI")
        @bookvh1 = @user.owned_books.where(:era => "VH1")
        @bookvh2 = @user.owned_books.where(:era => "VH2")
      end
      @bookcsv = @user.owned_books.where(:era => "VEI").order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "current-valiantcollection-#{Date.today}.csv" }
      end
  end

  def mybooksvh1
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Collection"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Collection"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Collection"
    end
      if params[:query].present?
        @book = @user.owned_books.where(:title => params[:query]).where(:era => "VH1").page(params[:page]).per(24)
      else
        @book = @user.owned_books.where(:era => "VH1").order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:era => "VEI")
        @bookvh1 = @user.owned_books.where(:era => "VH1")
        @bookvh2 = @user.owned_books.where(:era => "VH2")
      end
      @bookcsv = @user.owned_books.where(:era => "VH1").order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "classic-valiantcollection-#{Date.today}.csv" }
      end
  end

  def mybooksvh2
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Collection"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Collection"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Collection"
    end
      if params[:query].present?
        @book = @user.owned_books.where(:title => params[:query]).where(:era => "VH2").page(params[:page]).per(24)
      else
        @book = @user.owned_books.where(:era => "VH2").order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:era => "VEI")
        @bookvh1 = @user.owned_books.where(:era => "VH1")
        @bookvh2 = @user.owned_books.where(:era => "VH2")
      end
      @bookcsv = @user.owned_books.where(:era => "VH2").order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "acclaim-collection-#{Date.today}.csv" }
      end
  end  

  # EVENTS
  def event4001ad
    @pgtitle = "4001 A.D. Reading Order"
    @books = Book.where(:event => "4001 A.D.").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def eventshw
    @pgtitle = "Harbinger Wars Reading Order"
    @books = Book.where(:event => "Harbinger Wars").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def eventsah
    @pgtitle = "Armor Hunters Readering Order"
    @books = Book.where(:event => "Armor Hunters").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def eventsbod
    @pgtitle = "Book of Death Reading Order"
    @books = Book.where(:event => "Book of Death").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

   def eventschaoseffect
    @pgtitle = "Chaos Effect"
    @books = Book.where(:event => "Chaos Effect").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def eventsunity
    @pgtitle = "Unity"
    @books = Book.where(:event => "Unity").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def valuesmissing
    @pgtitle = "All with missing values"
    @tcount = Book.all.where(:pricenm => nil).where.not(:category => "Sketch").where.not(:category => "Paperback").where.not(:category => "Hardcover").count
    @book = Book.all.where("rdate < ?", Date.today).where(:pricenm => nil).where.not(:category => "Sketch").where.not(:category => "Paperback").where.not(:category => "Hardcover").order(title: :asc, issue: :asc).page(params[:page]).per(24)
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:pricenm => nil).where.not(:category => "Sketch").where.not(:category => "Paperback").where.not(:category => "Hardcover").order(title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "missingvalues-#{DateTime.now}.csv" }
    end
  end

  def all
    @pgtitle = "All"
    @search_count = Book.all.where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @book = Book.all.where(:era => "VEI").where(:category => params[:type]).where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:era => "VEI").where(:category => params[:type]).where.not(:category => "Sketch").count
    elsif params[:number].present?
      @book = Book.all.where(:era => "VEI").where(:issue => params[:number]).where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:era => "VEI").where(:issue => params[:number]).where.not(:category => "Sketch").count
    else
      @tcount = Book.all.where(:era => "VEI").count
      @book = Book.all.where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allcurrent-valiant-#{DateTime.now}.csv" }
    end
  end

  def alltbl
    @pgtitle = "All"
    if params[:type].present?
      @tcount = Book.all.where(:era => "VEI").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.all.where(:era => "VEI").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:era => "VEI").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.all.where(:era => "VEI").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:era => "VEI").where.not(:category => "Sketch").count
      @book = Book.all.where(:era => "VEI").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def allmissing
    @pgtitle = "All (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where("rdate > ?", "2012-05-01").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:era => "VEI").where(:category => params[:type]).where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:era => "VEI").where(:category => params[:type]).where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:era => "VEI").where(:issue => params[:number]).where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:era => "VEI").where(:issue => params[:number]).where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:era => "VEI").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:era => "VEI").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allcurrent-valiant-#{DateTime.now}.csv" }
    end
  end

  def alltblmissing
    @pgtitle = "All (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:era => "VEI").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:era => "VEI").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:era => "VEI").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:era => "VEI").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:era => "VEI").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:era => "VEI").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def alladmin
    @pgtitle = "Data export"
    @tcount = Book.all.count
    @book = Book.all.where.not(:category => "Sketch").order(title: :asc, rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book_csv = Book.all.where.not(:category => "Sketch").order(publisher: :desc, title: :asc, rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.csv { send_data @book_csv.ext_csv, filename: "vfans-export-#{DateTime.now}.csv" }
    end
  end

  def import
    Book.import(params[:file])
    redirect_to root_url, notice: "Books imported."
  end

  def ad4001
    @pgtitle = "4001 A.D."
    @search_count = Book.where("title like ?", "%4001 A.D.%").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where("title like ?", "%4001 A.D.%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%4001 A.D.%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%4001 A.D.%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%4001 A.D.").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%4001 A.D.%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%4001 A.D.%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @tcount = Book.all.where("title like ?", "%4001 A.D.%").where.not(:category => "Sketch").where("rdate > ?", "2012-05-01").count
    @bookcsv = Book.where("title like ?", "%4001 A.D.%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "4001ad-vei-#{DateTime.now}.csv" }
    end
  end

  def ad4001tbl
    @pgtitle = "4001 A.D."
    if params[:type].present?
      @tcount = Book.where("title like ?", "%4001 A.D.%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%4001 A.D.%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%4001 A.D.%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%4001 A.D.%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%4001 A.D.%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%4001 A.D.%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def ad4001missing
    @pgtitle = "4001 A.D. (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @tcount = Book.where.not(id: current_user.owned_book_ids).all.where("title like ?", "%4001 A.D.%").where.not(:category => "Sketch").where("rdate > ?", "2012-05-01").count
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "4001ad-vei-#{DateTime.now}.csv" }
    end
  end

  def ad4001tblmissing
    @pgtitle = "4001 A.D. (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%4001 A.D.%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end


  def aa
    @pgtitle = "A&A"
    @search_count = Book.where("title like ?", "%A&A%").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @tcount = Book.all.where("title like ?", "%A&A%").where.not(:category => "Sketch").where("rdate > ?", "2012-05-01").count
    @bookcsv = Book.where("title like ?", "%A&A%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "aaadventures-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def aatbl
    @pgtitle = "A&A"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def aamissing
    @pgtitle = "A&A (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @tcount = Book.where.not(id: current_user.owned_book_ids).all.where("title like ?", "%A&A%").where.not(:category => "Sketch").where("rdate > ?", "2012-05-01").count
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "aaadventures-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def aatblmissing
    @pgtitle = "A&A (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def archerarmstrong
    @pgtitle = "Archer and Armstrong"
    @search_count = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @tcount = Book.all.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where.not(:category => "Sketch").where("rdate > ?", "2012-05-01").count
    @bookcsv = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "archerarmstrong-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def archerarmstrongtbl
    @pgtitle = "Archer and Armstrong"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def archerarmstrongmissing
    @pgtitle = "Archer and Armstrong (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @tcount = Book.where.not(id: current_user.owned_book_ids).all.where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where.not(:category => "Sketch").where("rdate > ?", "2012-05-01").count
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "archerarmstrong-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def archerarmstrongtblmissing
    @pgtitle = "Archer and Armstrong (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Archer%").where.not("title like ?", "%A&A%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def armorhunters
    @pgtitle = "Armor Hunters"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Armor Hunter%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "armorhunters-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def armorhunterstbl
    @pgtitle = "Armor Hunters"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Armor Hunter%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def armorhuntersmissing
    @pgtitle = "Armor Hunters (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunter%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "armorhunters-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def armorhunterstblmissing
    @pgtitle = "Armor Hunters (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunter%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Armor Hunters%").where.not(:title => "Armor Hunters Special FCBD").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def armorhuntersbloodshot
    @pgtitle = "Armor Hunters Bloodshot"
    if params[:type].present?
      @tcount = Book.where(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Armor Hunters: Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "armorhuntersbloodshot-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def armorhuntersbloodshottbl
    @pgtitle = "Armor Hunters Bloodshot"
    if params[:type].present?
      @tcount = Book.where(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def armorhuntersbloodshotmissing
    @pgtitle = "Armor Hunters Bloodshot (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "armorhuntersbloodshot-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def armorhuntersbloodshottblmissing
    @pgtitle = "Armor Hunters Bloodshot (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def bloodshot
    @pgtitle = "Bloodshot"
    if params[:type].present?
      @tcount = Book.where(:title => "Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "bloodshot-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def bloodshottbl
    @pgtitle = "Bloodshot"
    if params[:type].present?
      @tcount = Book.where(:title => "Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def bloodshotmissing
    @pgtitle = "Bloodshot (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "bloodshot-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def bloodshottblmissing
    @pgtitle = "Bloodshot (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

 def bloodshotreborn
    @pgtitle = "Bloodshot Reborn"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "bloodshotreborn-vei-#{DateTime.now}.csv" }
      format.js
    end
end

def bloodshotrebornmissing
    @pgtitle = "Bloodshot Reborn (Missing)"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "bloodshotreborn-missing-vei-#{DateTime.now}.csv" }
      format.js
    end
end

  def bloodshotreborntbl
    @pgtitle = "Bloodshot Reborn"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def bloodshotreborntblmissing
    @pgtitle = "Bloodshot Reborn (Missing)"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).count
      @book = Book.where("title like ?", "%Bloodshot Reborn%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def fallofbloodshot
    @pgtitle = "The Fall of Bloodshot"
    @search_count = Book.where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: The Fall of Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Book of Death: The Fall of Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "fallofbloodshot-#{DateTime.now}.csv" }
    end
  end

  def fallofbloodshottbl
    @pgtitle = "The Fall of Bloodshot"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: The Fall of Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def fallofbloodshotmissing
    @pgtitle = "The Fall of Bloodshot (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "fallofbloodshot-#{DateTime.now}.csv" }
    end
  end

  def fallofbloodshottblmissing
    @pgtitle = "The Fall of Bloodshot (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end


  def bookofdeath
    @pgtitle = "Book of Death"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Book of Death").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "bookofdeath-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def bookofdeathtbl
    @pgtitle = "Book of Death"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Book of Death%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def bookofdeathmissing
    @pgtitle = "Book of Death (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "bookofdeath-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def bookofdeathtblmissing
    @pgtitle = "Book of Death (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Book of Death%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def legendsofthegeomancer
    @pgtitle = "Legend of the Geomancer"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: Legends of the Geomancer").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: Legends of the Geomancer").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: Legends of the Geomancer").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: Legends of the Geomancer").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: Legends of the Geomancer").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: Legends of the Geomancer").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Book of Death: Legends of the Geomancer").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "legendofthegeomancer-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def legendsofthegeomancertbl
    @pgtitle = "Legend of the Geomancer"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: Legends of the Geomancer").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: Legends of the Geomancer").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: Legends of the Geomancer").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: Legends of the Geomancer").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: Legends of the Geomancer").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: Legends of the Geomancer").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def legendsofthegeomancermissing
    @pgtitle = "Legend of the Geomancer (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "legendofthegeomancer-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def legendsofthegeomancertblmissing
    @pgtitle = "Legend of the Geomancer (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: Legends of the Geomancer").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def delinquents
    @pgtitle = "The Delinquents"
    if params[:type].present?
      @tcount = Book.where(:title => "The Delinquents").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Delinquents").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "The Delinquents").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Delinquents").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "The Delinquents").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Delinquents").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "The Delinquents").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "delinquents-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def delinquentstbl
    @pgtitle = "The Delinquents"
    if params[:type].present?
      @tcount = Book.where(:title => "The Delinquents").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Delinquents").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "The Delinquents").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Delinquents").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "The Delinquents").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Delinquents").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def delinquentsmissing
    @pgtitle = "The Delinquents (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "delinquents-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def delinquentstblmissing
    @pgtitle = "The Delinquents (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Delinquents").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def divinity
    @pgtitle = "Divinity"
    if params[:type].present?
      @tcount = Book.where(:title => "Divinity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Divinity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Divinity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Divinity").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "divinity-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def divinitytbl
    @pgtitle = "Divinity"
    if params[:type].present?
      @tcount = Book.where(:title => "Divinity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Divinity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Divinity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def divinitymissing
    @pgtitle = "Divinity (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "divinity-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def divinitytblmissing
    @pgtitle = "Divinity (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def divinity2
    @pgtitle = "Divinity II"
    if params[:type].present?
      @tcount = Book.where(:title => "Divinity II").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity II").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Divinity II").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity II").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Divinity II").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity II").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Divinity II").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "divinity2-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def divinity2tbl
    @pgtitle = "Divinity II"
    if params[:type].present?
      @tcount = Book.where(:title => "Divinity II").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity II").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Divinity II").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity II").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Divinity II").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Divinity II").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def divinity2missing
    @pgtitle = "Divinity II (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "divinity2-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def divinity2tblmissing
    @pgtitle = "Divinity II (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Divinity II").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

 def deaddrop
    @pgtitle = "Dead Drop"
    if params[:type].present?
      @tcount = Book.where(:title => "Dead Drop").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Dead Drop").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Dead Drop").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Dead Drop").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Dead Drop").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Dead Drop").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Dead Drop").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "deaddrop-vei-#{DateTime.now}.csv" }
      format.js
    end  
 end

 def deaddroptbl
    @pgtitle = "Dead Drop"
    if params[:type].present?
      @tcount = Book.where(:title => "Dead Drop").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Dead Drop").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Dead Drop").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Dead Drop").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Dead Drop").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Dead Drop").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end 
 end

 def deaddropmissing
    @pgtitle = "Dead Drop (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "deaddrop-vei-#{DateTime.now}.csv" }
      format.js
    end  
 end

 def deaddroptblmissing
    @pgtitle = "Dead Drop (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Dead Drop").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end 
 end

 def drmirage
    @pgtitle = "Death Defying Doctor Mirage"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%DDeath Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "drmirage-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def drmiragetbl
    @pgtitle = "Death Defying Doctor Mirage"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def drmiragemissing
    @pgtitle = "Death Defying Doctor Mirage (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%DDeath Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "drmirage-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def drmiragetblmissing
    @pgtitle = "Death Defying Doctor Mirage (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Death Defying Dr. Mirage%").where.not("title like ?", "%Dr. Mirage: Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def drmirage2
    @pgtitle = "Doctor Mirage Second Lives"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Second Lives%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "drmiragesecondlives-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def drmirage2tbl
    @pgtitle = "Doctor Mirage Second Lives"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def drmirage2missing
    @pgtitle = "Doctor Mirage Second Lives (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "drmiragesecondlives-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def drmirage2tblmissing
    @pgtitle = "Doctor Mirage Second Lives (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Second Lives%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def eternalwarrior
    @pgtitle = "Eternal Warrior"
    if params[:type].present?
      @tcount = Book.where(:title => "Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Eternal Warrior").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "eternalwarrior-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def eternalwarriortbl
    @pgtitle = "Eternal Warrior"
    if params[:type].present?
      @tcount = Book.where(:title => "Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def eternalwarriormissing
    @pgtitle = "Eternal Warrior (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "eternalwarrior-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def eternalwarriortblmissing
    @pgtitle = "Eternal Warrior (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def eternalwarriordaysofsteel
    @pgtitle = "Eternal Warrior Days of Steel"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "eternalwarriordaysofsteel-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def eternalwarriordaysofsteeltbl
    @pgtitle = "Eternal Warrior Days of Steel"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def eternalwarriordaysofsteelmissing
    @pgtitle = "Eternal Warrior Days of Steel (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "eternalwarriordaysofsteel-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def eternalwarriordaysofsteeltblmissing
    @pgtitle = "Eternal Warrior Days of Steel (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Eternal Warrior: Days of Steel%").where("rdate > ?", "2012-05-01").where.not(:title => "Wrath of the Eternal Warrior").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def faith
    @pgtitle = "Faith"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Faith%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Faith%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Faith%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Faith%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Faith%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Faith%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Faith%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "faith-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def faithtbl
    @pgtitle = "Faith"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Faith%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Faith%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Faith%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Faith%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Faith%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Faith%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def faithmissing
    @pgtitle = "Faith (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "faith-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def faithtblmissing
    @pgtitle = "Faith (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Faith%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def harbinger
    @pgtitle = "Harbinger"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "harbinger-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def harbingertbl
    @pgtitle = "Harbinger"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def harbingermissing
    @pgtitle = "Harbinger (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "harbinger-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def harbingertblmissing
    @pgtitle = "Harbinger (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger%").where.not("title like ?", "%Harbinger Wars%").where.not(:title => "Book of Death: The Fall of Harbinger").where.not(:title => "Armor Hunters: Harbinger").where.not(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def harbingeromegas
    @pgtitle = "Harbinger: Omegas"
    if params[:type].present?
      @tcount = Book.where(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Harbinger: Omegas").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "harbingeromegas-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def harbingeromegastbl
    @pgtitle = "Harbinger: Omegas"
    if params[:type].present?
      @tcount = Book.where(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def harbingeromegasmissing
    @pgtitle = "Harbinger: Omegas (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "harbingeromegas-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def harbingeromegastblmissing
    @pgtitle = "Harbinger: Omegas (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Harbinger: Omegas").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def harbingerwars
    @pgtitle = "Harbinger Wars"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Harbinger Wars%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger Wars%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Harbinger Wars%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger Wars%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Harbinger Wars%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger Wars%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Harbinger Wars%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "harbingerwars-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def harbingerwarstbl
    @pgtitle = "Harbinger Wars"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Harbinger Wars%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger Wars%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Harbinger Wars%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger Wars%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Harbinger Wars%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Harbinger Wars%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def harbingerwarsmissing
    @pgtitle = "Harbinger Wars (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "harbingerwars-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def harbingerwarstblmissing
    @pgtitle = "Harbinger Wars (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Harbinger Wars%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def armorhuntersharbinger
    @pgtitle = "Armor Hunters Harbinger"
    if params[:type].present?
      @tcount = Book.where(:title => "Armor Hunters: Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Armor Hunters: Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Armor Hunters: Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Armor Hunters: Harbinger").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "armorhuntersharbinger-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def armorhuntersharbingertbl
    @pgtitle = "Armor Hunters Harbinger"
    if params[:type].present?
      @tcount = Book.where(:title => "Armor Hunters: Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Armor Hunters: Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Armor Hunters: Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Armor Hunters: Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def armorhuntersharbingermissing
    @pgtitle = "Armor Hunters Harbinger (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "armorhuntersharbinger-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def armorhuntersharbingertblmissing
    @pgtitle = "Armor Hunters Harbinger (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Armor Hunters: Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def fallofharbinger
    @pgtitle = "Fall of Harbinger"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: The Fall of Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Book of Death: The Fall of Harbinger").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "fallofharbinger-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def fallofharbingertbl
    @pgtitle = "Fall of Harbinger"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: The Fall of Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def fallofharbingermissing
    @pgtitle = "Fall of Harbinger (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "fallofharbinger-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def fallofharbingertblmissing
    @pgtitle = "Fall of Harbinger (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Harbinger").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def imperium
    @pgtitle = "Imperium"
    if params[:type].present?
      @tcount = Book.where(:title => "Imperium").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Imperium").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Imperium").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Imperium").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Imperium").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Imperium").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Imperium").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "imperium-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def imperiumtbl
    @pgtitle = "Imperium"
    if params[:type].present?
      @tcount = Book.where(:title => "Imperium").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Imperium").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Imperium").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Imperium").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Imperium").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Imperium").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def imperiummissing
    @pgtitle = "Imperium (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "imperium-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def imperiumtblmissing
    @pgtitle = "Imperium (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Imperium").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def ivar
    @pgtitle = "Ivar, Timewalker"
    if params[:type].present?
      @tcount = Book.where(:title => "Ivar, Timewalker").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ivar, Timewalker").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Ivar, Timewalker").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ivar, Timewalker").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Ivar, Timewalker").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ivar, Timewalker").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Ivar, Timewalker").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "ivar-vei-#{DateTime.now}.csv" }
      format.js
    end
  end 

  def ivartbl
    @pgtitle = "Ivar, Timewalker"
    if params[:type].present?
      @tcount = Book.where(:title => "Ivar, Timewalker").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ivar, Timewalker").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Ivar, Timewalker").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ivar, Timewalker").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Ivar, Timewalker").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ivar, Timewalker").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end 

  def ivarmissing
    @pgtitle = "Ivar, Timewalker (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "ivar-vei-#{DateTime.now}.csv" }
      format.js
    end
  end 

  def ivartblmissing
    @pgtitle = "Ivar, Timewalker (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ivar, Timewalker").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end 

  def keys
    @pgtitle = "Key Issues (2012-)"
    @books = Book.where(:iskey => true).where("rdate > ?", "2012-05-01").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def ninjak
    @pgtitle = "Ninjak"
    if params[:type].present?
      @tcount = Book.where(:title => "Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Ninjak").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "ninjak-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def ninjaktbl
    @pgtitle = "Ninjak"
    if params[:type].present?
      @tcount = Book.where(:title => "Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def ninjakmissing
    @pgtitle = "Ninjak (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "ninjak-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def ninjaktblmissing
    @pgtitle = "Ninjak (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def fallofninjak
    @pgtitle = "The Fall of Ninjak"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: The Fall of Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Book of Death: The Fall of Ninjak").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "fallofninjak-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def fallofninjaktbl
    @pgtitle = "The Fall of Ninjak"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: The Fall of Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def fallofninjakmissing
    @pgtitle = "The Fall of Ninjak (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "fallofninjak-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def fallofninjaktblmissing
    @pgtitle = "The Fall of Ninjak (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of Ninjak").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def previews
    @pgtitle = "Promos"
    if params[:type].present?
      @tcount = Book.where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:category => "Promo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:category => "Promo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:category => "Promo").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "previews-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def previewstbl
    @pgtitle = "Promos"
    if params[:type].present?
      @tcount = Book.where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:category => "Promo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:category => "Promo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def previewsmissing
    @pgtitle = "Promos (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "previews-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def previewstblmissing
    @pgtitle = "Promos (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:category => "Promo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def punkmambo
    @pgtitle = "Punk Mambo"
    if params[:type].present?
      @tcount = Book.where(:title => "Punk Mambo").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Punk Mambo").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Punk Mambo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Punk Mambo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Punk Mambo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Punk Mambo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Punk Mambo").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "punkmambo-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def punkmambotbl
    @pgtitle = "Punk Mambo"
    if params[:type].present?
      @tcount = Book.where(:title => "Punk Mambo").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Punk Mambo").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Punk Mambo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Punk Mambo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Punk Mambo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Punk Mambo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def punkmambomissing
    @pgtitle = "Punk Mambo (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "punkmambo-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def punkmambotblmissing
    @pgtitle = "Punk Mambo (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Punk Mambo").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def quantumwoody
    @pgtitle = "Quantum and Woody"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Quantum % Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "quantumwoody-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def quantumwoodytbl
    @pgtitle = "Quantum and Woody"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def quantumwoodymissing
    @pgtitle = "Quantum and Woody (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum % Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "quantumwoody-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def quantumwoodytblmissing
    @pgtitle = "Quantum and Woody (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody%").where.not("writer like ?", "%Christopher Priest%").where.not("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def quantumwoodymustdie
    @pgtitle = "Quantum and Woody Must Die"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Quantum & Woody Must Die%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "quantumwoodymustdie-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def quantumwoodymustdietbl
    @pgtitle = "Quantum and Woody Must Die"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def quantumwoodymustdiemissing
    @pgtitle = "Quantum and Woody Must Die (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "quantumwoodymustdie-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def quantumwoodymustdietblmissing
    @pgtitle = "Quantum and Woody Must Die (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Quantum & Woody Must Die%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def q2
    @pgtitle = "Q2"
    if params[:type].present?
      @tcount = Book.where("writer like ?", "%Christopher Priest%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("writer like ?", "%Christopher Priest%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("writer like ?", "%Christopher Priest%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("writer like ?", "%Christopher Priest%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("writer like ?", "%Christopher Priest%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("writer like ?", "%Christopher Priest%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("writer like ?", "%Christopher Priest%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "q2-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def q2tbl
    @pgtitle = "Q2"
    if params[:type].present?
      @tcount = Book.where("writer like ?", "%Christopher Priest%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("writer like ?", "%Christopher Priest%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("writer like ?", "%Christopher Priest%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("writer like ?", "%Christopher Priest%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("writer like ?", "%Christopher Priest%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("writer like ?", "%Christopher Priest%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def q2missing
    @pgtitle = "Q2 (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "q2-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def q2tblmissing
    @pgtitle = "Q2 (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("writer like ?", "%Christopher Priest%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def rai
    @pgtitle = "Rai"
    if params[:type].present?
      @tcount = Book.where(:title => "Rai").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Rai").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Rai").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Rai").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Rai").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Rai").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Rai").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "rai-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def raitbl
    @pgtitle = "Rai"
    if params[:type].present?
      @tcount = Book.where(:title => "Rai").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Rai").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Rai").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Rai").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Rai").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Rai").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def raimissing
    @pgtitle = "Rai (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "rai-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def raitblmissing
    @pgtitle = "Rai (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Rai").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def shadowman
    @pgtitle = "Shadowman"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "shadowman-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def shadowmantbl
    @pgtitle = "Shadowman"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def shadowmanmissing
    @pgtitle = "Shadowman (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "shadowman-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def shadowmantblmissing
    @pgtitle = "Shadowman (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%Shadowman%").where.not(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def shadowmanendtimes
    @pgtitle = "Shadowman End Times"
    if params[:type].present?
      @tcount = Book.where(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Shadowman: End Times").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "shadowmanendtimes-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def shadowmanendtimestbl
    @pgtitle = "Shadowman End Times"
    if params[:type].present?
      @tcount = Book.where(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def shadowmanendtimesmissing
    @pgtitle = "Shadowman End Times (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "shadowmanendtimes-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def shadowmanendtimestblmissing
    @pgtitle = "Shadowman End Times (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Shadowman: End Times").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def sketch
    @pgtitle = "Sketch Covers"
    @search_count = Book.where(:category => "Sketch").where(:cover => params[:query]).where("rdate > ?", "2012-05-01").count
    @tcount = Book.all.where(:category => "Sketch").where("rdate > ?", "2012-05-01").where(status: "Active").count
    if params[:query].present?
      @book = Book.where(:category => "Sketch", status: "Active", :cover => params[:query]).order(created_at: :desc).page(params[:page]).per(24)
    else
      @book = Book.where(:category => "Sketch").where("rdate > ?", "2012-05-01").where(status: "Active").order(created_at: :desc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def sketchtbl
    @pgtitle = "Sketch Covers"
    @tcount = Book.all.where(:category => "Sketch").where("rdate > ?", "2012-05-01").where(status: "Active").count
    @book = Book.where(:category => "Sketch").where("rdate > ?", "2012-05-01").where(status: "Active").order(created_at: :desc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def thevaliant
    @pgtitle = "The Valiant"
    if params[:type].present?
      @tcount = Book.where(:title => "The Valiant").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Valiant").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "The Valiant").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Valiant").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "The Valiant").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Valiant").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "The Valiant").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "thevaliant-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def thevalianttbl
    @pgtitle = "The Valiant"
    if params[:type].present?
      @tcount = Book.where(:title => "The Valiant").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Valiant").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "The Valiant").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Valiant").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "The Valiant").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "The Valiant").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def thevaliantmissing
    @pgtitle = "The Valiant (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "thevaliant-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def thevalianttblmissing
    @pgtitle = "The Valiant (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "The Valiant").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def trades
    @pgtitle = "Trades"
    if params[:tradetitle].present?
      @tcount = Book.where("note like ?", "%Trade%").where(:title => params[:tradetitle]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("note like ?", "%Trade%").where(:title => params[:tradetitle]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("note like ?", "%Trade%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("note like ?", "%Trade%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("note like ?", "%Trade%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("note like ?", "%Trade%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def tradestbl
    @pgtitle = "Trades"
    if params[:tradetitle].present?
      @tcount = Book.where("note like ?", "%Trade%").where(:title => params[:tradetitle]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("note like ?", "%Trade%").where(:title => params[:tradetitle]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("note like ?", "%Trade%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("note like ?", "%Trade%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("note like ?", "%Trade%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("note like ?", "%Trade%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def tradesmissing
    @pgtitle = "Trades (Missing)"
    if params[:tradetitle].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where(:title => params[:tradetitle]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where(:title => params[:tradetitle]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def tradestblmissing
    @pgtitle = "Trades (Missing)"
    if params[:tradetitle].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where(:title => params[:tradetitle]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where(:title => params[:tradetitle]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("note like ?", "%Trade%").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def unity
    @pgtitle = "Unity"
    if params[:type].present?
      @tcount = Book.where(:title => "Unity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Unity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Unity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Unity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Unity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Unity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Unity").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "unity-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def unitytbl
    @pgtitle = "Unity"
    if params[:type].present?
      @tcount = Book.where(:title => "Unity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Unity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Unity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Unity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Unity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Unity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def unitymissing
    @pgtitle = "Unity (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "unity-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def unitytblmissing
    @pgtitle = "Unity (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Unity").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def wratheternalwarrior
    @pgtitle = "Wrath of the Eternal Warrior"
    if params[:type].present?
      @tcount = Book.where(:title => "Wrath of the Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Wrath of the Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Wrath of the Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Wrath of the Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Wrath of the Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Wrath of the Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Wrath of the Eternal Warrior").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "wrath-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def wratheternalwarriortbl
    @pgtitle = "Wrath of the Eternal Warrior"
    if params[:type].present?
      @tcount = Book.where(:title => "Wrath of the Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Wrath of the Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Wrath of the Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Wrath of the Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Wrath of the Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Wrath of the Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def wratheternalwarriormissing
    @pgtitle = "Wrath of the Eternal Warrior (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "wrath-vei-#{DateTime.now}.csv" }
      format.js
    end
  end

  def wratheternalwarriortblmissing
    @pgtitle = "Wrath of the Eternal Warrior (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Wrath of the Eternal Warrior").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def xomanowar
    @pgtitle = "X-O Manowar"
    @search_count = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "xomanowar-#{DateTime.now}.csv" }
    end
  end

  def xomanowartbl
    @pgtitle = "X-O Manowar"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def xomanowarmissing
    @pgtitle = "X-O Manowar (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "xomanowar-#{DateTime.now}.csv" }
    end
  end

  def xomanowartblmissing
    @pgtitle = "X-O Manowar (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar 25th Anniversary Special").where.not(:title => "X-O Manowar Annual").where.not(:title => "X-O Manowar: Commander Trill").where.not(:title => "4001 A.D.: X-O Manowar").where.not(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def xomanowarspecials
    @pgtitle = "X-O Manowar Specials"
    @search_count = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "xomanowarspecials-#{DateTime.now}.csv" }
    end
  end

  def xomanowarspecialstbl
    @pgtitle = "X-O Manowar Specials"
    if params[:type].present?
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def xomanowarspecialsmissing
    @pgtitle = "X-O Manowar Specials (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "xomanowarspecials-#{DateTime.now}.csv" }
    end
  end

  def xomanowarspecialstblmissing
    @pgtitle = "X-O Manowar Specials (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where("title like ?", "%X-O Manowar%").where.not(:title => "X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def ad4001bloodshot
    @pgtitle = "4001 A.D. Bloodshot"
    @search_count = Book.where(:title => "4001 A.D.: Bloodshot").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where(:title => "4001 A.D.: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "4001 A.D.: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "4001 A.D.: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "4001 A.D.: Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "ad4001bloodshot-#{DateTime.now}.csv" }
    end
  end

  def ad4001bloodshottbl
    @pgtitle = "4001 A.D. Bloodshot"
    if params[:type].present?
      @tcount = Book.where(:title => "4001 A.D.: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "4001 A.D.: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "4001 A.D.: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def ad4001bloodshotmissing
    @pgtitle = "4001 A.D. Bloodshot (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "ad4001bloodshot-#{DateTime.now}.csv" }
    end
  end

  def ad4001bloodshottblmissing
    @pgtitle = "4001 A.D. Bloodshot (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Bloodshot").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def ad4001shadowman
    @pgtitle = "4001 A.D. Shadowman"
    @search_count = Book.where(:title => "4001 A.D.: Shadowman").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where(:title => "4001 A.D.: Shadowman").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Shadowman").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "4001 A.D.: Shadowman").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Shadowman").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "4001 A.D.: Shadowman").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Shadowman").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "4001 A.D.: Shadowman").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "ad4001shadowman-#{DateTime.now}.csv" }
    end
  end

  def ad4001shadowmantbl
    @pgtitle = "4001 A.D. Shadowman"
    if params[:type].present?
      @tcount = Book.where(:title => "4001 A.D.: Shadowman").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Shadowman").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "4001 A.D.: Shadowman").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Shadowman").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "4001 A.D.: Shadowman").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: Shadowman").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def ad4001shadowmanmissing
    @pgtitle = "4001 A.D. Shadowman (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "ad4001shadowman-#{DateTime.now}.csv" }
    end
  end

  def ad4001shadowmantblmissing
    @pgtitle = "4001 A.D. Shadowman (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: Shadowman").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def ad4001xomanowar
    @pgtitle = "4001 A.D. X-O Manowar"
    @search_count = Book.where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "4001 A.D.: X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "4001 A.D.: X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "4001 A.D.: X-O Manowar").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "ad4001xomanowar-#{DateTime.now}.csv" }
    end
  end

  def ad4001xomanowartbl
    @pgtitle = "4001 A.D. X-O Manowar"
    if params[:type].present?
      @tcount = Book.where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "4001 A.D.: X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "4001 A.D.: X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "4001 A.D.: X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def ad4001xomanowarmissing
    @pgtitle = "4001 A.D. X-O Manowar (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "ad4001xomanowar-#{DateTime.now}.csv" }
    end
  end

  def ad4001xomanowartblmissing
    @pgtitle = "4001 A.D. X-O Manowar (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "4001 A.D.: X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def fallofxomanowar
    @pgtitle = "The Fall of X-O Manowar"
    @search_count = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "fallofxomanowar-#{DateTime.now}.csv" }
    end
  end

  def fallofxomanowartbl
    @pgtitle = "The Fall of X-O Manowar"
    if params[:type].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def fallofxomanowarmissing
    @pgtitle = "The Fall of X-O Manowar (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:query]).where("rdate > ?", "2012-05-01").count
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate < ?", Date.today).where(:era => "VEI").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "fallofxomanowar-#{DateTime.now}.csv" }
    end
  end

  def fallofxomanowartblmissing
    @pgtitle = "The Fall of X-O Manowar (Missing)"
    if params[:type].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where(:category => params[:type]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where(:issue => params[:number]).where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").count
      @book = Book.where.not(id: current_user.owned_book_ids).where(:title => "Book of Death: The Fall of X-O Manowar").where("rdate > ?", "2012-05-01").where.not(:category => "Sketch").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Clasic Valiant
  def vh1keys
    @pgtitle = "Key Issues (1991-1996)"
    @books = Book.where(:iskey => true).where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end 
  
  def vh1archerarmstrong
    @pgtitle = "Archer & Armstrong"
    @tcount = Book.all.where("title like ?", "%Archer & Armstrong%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Archer & Armstrong%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Archer & Armstrong%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1aa-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1archerarmstrongtbl
    @pgtitle = "Archer & Armstrong"
    @tcount = Book.all.where("title like ?", "%Archer & Armstrong%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Archer & Armstrong%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1armorines
    @pgtitle = "Armorines"
    @tcount = Book.all.where("title like ?", "%Armorines%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Armorines%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Armorines%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1armorines-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1armorinestbl
    @pgtitle = "Armorines"
    @tcount = Book.all.where("title like ?", "%Armorines%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Armorines%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1bloodshot
    @pgtitle = "Bloodshot"
    @tcount = Book.all.where("title like ?", "%Bloodshot%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Bloodshot%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Bloodshot%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1bloodshot-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1bloodshottbl
    @pgtitle = "Bloodshot"
    @tcount = Book.all.where("title like ?", "%Bloodshot%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Bloodshot%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1chaoseffect
    @pgtitle = "Chaos Effect"
    @tcount = Book.all.where("title like ?", "%Chaos Effect%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Chaos Effect%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Chaos Effect%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1chaoseffect-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1chaoseffecttbl
    @pgtitle = "Chaos Effect"
    @tcount = Book.all.where("title like ?", "%Chaos Effect%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Chaos Effect%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1deathmate
    @pgtitle = "Deathmate"
    @tcount = Book.all.where("title like ?", "%Deathmate%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Deathmate%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Deathmate%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1deathmate-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1deathmatetbl
    @pgtitle = "Deathmate"
    @tcount = Book.all.where("title like ?", "%Deathmate%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Deathmate%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1eternalwarrior
    @pgtitle = "Eternal Warrior"
    @tcount = Book.all.where("title like ?", "%Eternal Warrior%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Eternal Warrior%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Eternal Warrior%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1ew-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1eternalwarriortbl
    @pgtitle = "Eternal Warrior"
    @tcount = Book.all.where("title like ?", "%Eternal Warrior%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Eternal Warrior%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1geomancer
    @pgtitle = "Geomancer"
    @tcount = Book.all.where("title like ?", "%Geomancer%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Geomancer%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Geomancer%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1geomancer-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1geomancertbl
    @pgtitle = "Geomancer"
    @tcount = Book.all.where("title like ?", "%Geomancer%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Geomancer%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1harbinger
    @pgtitle = "Harbinger"
    @tcount = Book.all.where("title like ?", "%Harbinger%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Harbinger%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Harbinger%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1harbinger-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1harbingertbl
    @pgtitle = "Harbinger"
    @tcount = Book.all.where("title like ?", "%Harbinger%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Harbinger%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1hardcorps
    @pgtitle = "H.A.R.D. Corps"
    @tcount = Book.all.where("title like ?", "%H.A.R.D. Corps%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%H.A.R.D. Corps%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%H.A.R.D. Corps%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1hardcorps-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1hardcorpstbl
    @pgtitle = "H.A.R.D. Corps"
    @tcount = Book.all.where("title like ?", "%H.A.R.D. Corps%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%H.A.R.D. Corps%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1miscellaneous
    @pgtitle = "Miscellaneous"
    @tcount = Book.all.where("note like ?", "%Misc.%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("note like ?", "%Misc.%").where("rdate < ?", "1996-09-30").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("note like ?", "%Misc.%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1misc-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1miscellaneoustbl
    @pgtitle = "Miscellaneous"
    @tcount = Book.all.where("note like ?", "%Misc.%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("note like ?", "%Misc.%").where("rdate < ?", "1996-09-30").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1magnus
    @pgtitle = "Magnus Robot Fighter"
    @tcount = Book.all.where("title like ?", "%Magnus Robot Fighter%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Magnus Robot Fighter%").where("rdate < ?", "1996-09-30").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Magnus Robot Fighter%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1magnus-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1magnustbl
    @pgtitle = "Magnus Robot Fighter"
    @tcount = Book.all.where("title like ?", "%Magnus Robot Fighter%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Magnus Robot Fighter%").where("rdate < ?", "1996-09-30").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1mirage
    @pgtitle = "Second Life of Doctor Mirage"
    @tcount = Book.all.where("title like ?", "%Mirage%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Mirage%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Mirage%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1mirage-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1miragetbl
    @pgtitle = "Second Life of Doctor Mirage"
    @tcount = Book.all.where("title like ?", "%Mirage%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Mirage%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1ninjak
    @pgtitle = "Ninjak"
    @tcount = Book.all.where("title like ?", "%Ninjak%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Ninjak%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Ninjak%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1ninjak-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1ninjaktbl
    @pgtitle = "Ninjak"
    @tcount = Book.all.where("title like ?", "%Ninjak%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Ninjak%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1thevisitor
    @pgtitle = "The Visitor"
    @tcount = Book.all.where("title like ?", "%The Visitor%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%The Visitor%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%The Visitor%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1visitor-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1thevisitortbl
    @pgtitle = "The Visitor"
    @tcount = Book.all.where("title like ?", "%The Visitor%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%The Visitor%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1psilords
    @pgtitle = "Psi-Lords"
    @tcount = Book.all.where("title like ?", "%Psi-Lords%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Psi-Lords%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Psi-Lords%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1psilords-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1psilordstbl
    @pgtitle = "Psi-Lords"
    @tcount = Book.all.where("title like ?", "%Psi-Lords%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Psi-Lords%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1rai
    @pgtitle = "Rai"
    @tcount = Book.all.where("title like ?", "%Rai%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Rai%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Rai%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1rai-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1raitbl
    @pgtitle = "Rai"
    @tcount = Book.all.where("title like ?", "%Rai%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Rai%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1secretweapons
    @pgtitle = "Secret Weapons"
    @tcount = Book.all.where("title like ?", "%Secret Weapons%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Secret Weapons%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Secret Weapons%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1secretweapons-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1secretweaponstbl
    @pgtitle = "Shadowman"
    @tcount = Book.all.where("title like ?", "%Secret Weapons%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Secret Weapons%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1shadowman
    @pgtitle = "Shadowman"
    @tcount = Book.all.where("title like ?", "%Shadowman%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Shadowman%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Shadowman%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1shadowman-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1shadowmantbl
    @pgtitle = "Shadowman"
    @tcount = Book.all.where("title like ?", "%Shadowman%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Shadowman%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1solar
    @pgtitle = "Solar Man of the Atom"
    @tcount = Book.all.where("title like ?", "%Solar%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Solar%").where("rdate < ?", "1996-09-30").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Solar%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1solar-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1solartbl
    @pgtitle = "Solar Man of the Atom"
    @tcount = Book.all.where("title like ?", "%Solar%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Solar%").where("rdate < ?", "1996-09-30").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1timewalker
    @pgtitle = "Timewalker"
    @tcount = Book.all.where("title like ?", "%Timewalker%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Timewalker%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Timewalker%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1timewalker-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1timewalkertbl
    @pgtitle = "Timewalker"
    @tcount = Book.all.where("title like ?", "%Timewalker%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Timewalker%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1trades
    @pgtitle = "Trades"
    @tcount = Book.all.where("note like ?", "%Trade%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("note like ?", "%Trade%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1tradestbl
    @pgtitle = "Trades"
    @tcount = Book.all.where("note like ?", "%Trade%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("note like ?", "%Trade%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1turok
    @pgtitle = "Turok: Dinosaur Hunter"
    @tcount = Book.all.where("title like ?", "%Turok%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Turok%").where("rdate < ?", "1996-09-30").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Turok%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1turok-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1turoktbl
    @pgtitle = "Turok: Dinosaur Hunter"
    @tcount = Book.all.where("title like ?", "%Turok%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Turok%").where("rdate < ?", "1996-09-30").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1unity
    @pgtitle = "Unity"
    @tcount = Book.all.where("title like ?", "%Unity%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Unity%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Unity%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1unity-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1unitytbl
    @pgtitle = "Unity"
    @tcount = Book.all.where("title like ?", "%Unity%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Unity%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1xomanowar
    @pgtitle = "X-O Manowar"
    @tcount = Book.all.where("title like ?", "%X-O Manowar%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%X-O Manowar%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%X-O Manowar%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1xomanowar-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1xomanowartbl
    @pgtitle = "X-O Manowar"
    @tcount = Book.all.where("title like ?", "%X-O Manowar%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%X-O Manowar%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1all
    @pgtitle = "All Classic"
    @tcount = Book.all.where(:era => "VH1").count
    @book = Book.all.where(:era => "VH1").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1alltbl
    @pgtitle = "All Classic"
    @tcount = Book.all.where(:era => "VH1").count
    @book = Book.all.where(:era => "VH1").order(rdate: :asc, issue: :asc).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh1voice
    @pgtitle = "Valiant Voice"
    @tcount = Book.where("title like ?", "%Valiant Voice%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Valiant Voice%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Valiant Voice%").where("rdate < ?", Date.today).where(:era => "VH1").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.xml { send_data @bookcsv.super_csv, filename: "vh1voice-#{DateTime.now}.csv" }
      format.js
    end
  end

  def vh1voicetbl
    @pgtitle = "Valiant Voice"
    @tcount = Book.where("title like ?", "%Valiant Voice%").where("rdate < ?", "1996-09-30").count
    @book = Book.where("title like ?", "%Valiant Voice%").where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Acclaim
  def vh2all
    @pgtitle = "All Acclaim"
    @tcount = Book.all.where(:era => "VH2").count
    @book = Book.all.where(:era => "VH2").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2alltbl
    @pgtitle = "All Acclaim"
    @tcount = Book.all.where(:era => "VH2").count
    @book = Book.all.where(:era => "VH2").order(rdate: :asc, issue: :asc).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2az
    @pgtitle = "Acclaim Adventure Zone"
    @tcount = Book.where("title like ?", "%Adventure Zone%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Adventure Zone%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Adventure Zone%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "adventurezone-#{DateTime.now}.csv" }
    end
  end

  def vh2aztbl
    @pgtitle = "Acclaim Adventure Zone"
    @tcount = Book.all.where("title like ?", "%Adventure Zone%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Adventure Zone%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2armorines
    @pgtitle = "Armorines"
    @tcount = Book.where(:title => "Armorines").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Armorines").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where(:title => "Armorines").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "armorines-#{DateTime.now}.csv" }
    end
  end

  def vh2armorinestbl
    @pgtitle = "Armorines"
    @tcount = Book.all.where(:title => "Armorines").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Armorines").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2bs
    @pgtitle = "Bloodshot"
    @tcount = Book.where("title like ?", "%Bloodshot%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Bloodshot%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Bloodshot%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "bloodshot-#{DateTime.now}.csv" }
    end
  end

  def vh2bstbl
    @pgtitle = "Bloodshot"
    @tcount = Book.all.where("title like ?", "%Bloodshot%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Bloodshot%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2dp
    @pgtitle = "Darque Passages"
    @tcount = Book.where(:title => "Darque Passages").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Darque Passages").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where(:title => "Darque Passages").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "darquepassages-#{DateTime.now}.csv" }
    end
  end

  def vh2dptbl
    @pgtitle = "Darque Passages"
    @tcount = Book.all.where(:title => "Darque Passages").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Darque Passages").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2ds
    @pgtitle = "Deadside"
    @tcount = Book.where(:title => "Deadside").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Deadside").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where(:title => "Deadside").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "deadside-#{DateTime.now}.csv" }
    end
  end

  def vh2dstbl
    @pgtitle = "Deadside"
    @tcount = Book.all.where(:title => "Deadside").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Deadside").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2drt
    @pgtitle = "Doctor Tomorrow"
    @tcount = Book.where(:title => "Doctor Tomorrow").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Doctor Tomorrow").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where(:title => "Doctor Tomorrow").where("rdate > ?", "1996-09-30").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "doctortomorrow-#{DateTime.now}.csv" }
    end
  end

  def vh2drttbl
    @pgtitle = "Doctor Tomorrow"
    @tcount = Book.all.where(:title => "Doctor Tomorrow").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Doctor Tomorrow").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2ews
    @pgtitle = "Eternal Warriors"
    @tcount = Book.where("title like ?", "%Eternal Warriors%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Eternal Warriors%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Eternal Warriors%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "eternalwarriors-#{DateTime.now}.csv" }
    end
  end

  def vh2ewstbl
    @pgtitle = "Eternal Warriors"
    @tcount = Book.all.where("title like ?", "%Eternal Warriors%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Eternal Warriors%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2magnus
    @pgtitle = "Magnus Robor Fighter"
    @tcount = Book.where("title like ?", "%Magnus Robot Fighter%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Magnus Robot Fighter%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Magnus Robot Fighter%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "magnus-#{DateTime.now}.csv" }
    end
  end

  def vh2magnustbl
    @pgtitle = "Magnus Robot Fighter"
    @tcount = Book.all.where("title like ?", "%Magnus Robot Fighter%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Magnus Robot Fighter%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2ninjak
    @pgtitle = "Ninjak"
    @tcount = Book.where("title like ?", "%Ninjak%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Ninjak%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Ninjak%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "ninjak-#{DateTime.now}.csv" }
    end
  end

  def vh2ninjaktbl
    @pgtitle = "Ninjak"
    @tcount = Book.all.where("title like ?", "%Ninjak%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Ninjak%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2nio
    @pgtitle = "N.I.O."
    @tcount = Book.where(:title => "N.I.O.").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "N.I.O.").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where(:title => "N.I.O.").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "bloodshot-#{DateTime.now}.csv" }
    end
  end

  def vh2niotbl
    @pgtitle = "N.I.O."
    @tcount = Book.all.where(:title => "N.I.O.").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "N.I.O.").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2misc
    @pgtitle = "Miscellaneous"
    @tcount = Book.where(:category => "Misc").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:category => "Misc").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(rdate: :asc, issue: :asc, title: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where(:category => "Misc").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(rdate: :asc, issue: :asc, title: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "misc-#{DateTime.now}.csv" }
    end
  end

  def vh2misctbl
    @pgtitle = "Miscellaneous"
    @tcount = Book.all.where(:category => "Misc").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:category => "Misc").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(rdate: :asc, issue: :asc, title: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2qw
    @pgtitle = "Quantum & Woody"
    @tcount = Book.where("title like ?", "%Quantum & Woody%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Quantum & Woody%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Quantum & Woody%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "quantumwoody-#{DateTime.now}.csv" }
    end
  end

  def vh2qwtbl
    @pgtitle = "Quantum & Woody"
    @tcount = Book.all.where("title like ?", "%Quantum & Woody%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Quantum & Woody%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2sha2
    @pgtitle = "Shadowman Vol. 2"
    @tcount = Book.where("title like ?","%Shadowman Vol. 2%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Shadowman Vol. 2%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Shadowman Vol. 2%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "shadowman2-#{DateTime.now}.csv" }
    end
  end

  def vh2sha2tbl
    @pgtitle = "Shadowman Vol. 2"
    @tcount = Book.all.where("title like ?", "%Shadowman Vol. 2%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Shadowman Vol. 2%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end 

  def vh2sha3
    @pgtitle = "Shadowman Vol. 3"
    @tcount = Book.where(:title => "Shadowman Vol. 3").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Shadowman Vol. 3").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where(:title => "Shadowman Vol. 3").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "shadowman3-#{DateTime.now}.csv" }
    end
  end

  def vh2sha3tbl
    @pgtitle = "Shadowman Vol. 3"
    @tcount = Book.all.where(:title => "Shadowman Vol. 3").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Shadowman Vol. 3").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2solar
    @pgtitle = "Solar: Hell On Earth"
    @tcount = Book.where(:title => "Solar: Hell On Earth").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Solar: Hell On Earth").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where(:title => "Solar: Hell On Earth").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "solar-#{DateTime.now}.csv" }
    end
  end

  def vh2solartbl
    @pgtitle = "Solar: Hell On Earth"
    @tcount = Book.all.where(:title => "Solar: Hell On Earth").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where(:title => "Solar: Hell On Earth").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2ta
    @pgtitle = "Trinity Angels"
    @tcount = Book.where("title like ?", "%Trinity Angels%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Trinity Angels%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Trinity Angels%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "trinityangels-#{DateTime.now}.csv" }
    end
  end

  def vh2tatbl
    @pgtitle = "Trinity Angels"
    @tcount = Book.all.where("title like ?", "%Trinity Angels%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Trinity Angels%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2tm
    @pgtitle = "Troublemakers"
    @tcount = Book.where("title like ?", "%Troublemakers%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Troublemakers%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Troublemakers%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "troublemakers-#{DateTime.now}.csv" }
    end
  end

  def vh2tmtbl
    @pgtitle = "Troublemakers"
    @tcount = Book.all.where("title like ?", "%Troublemakers%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Troublemakers%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2turok
    @pgtitle = "Turok"
    @tcount = Book.where("title like ?", "%Turok%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Turok%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Turok%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "turok-#{DateTime.now}.csv" }
    end
  end

  def vh2turoktbl
    @pgtitle = "Turok"
    @tcount = Book.where("title like ?", "%Turok%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Turok%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2unity
    @pgtitle = "Unity 2000"
    @tcount = Book.where("title like ?", "%Unity 2000%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Unity 2000%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Unity 2000%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "unity2000-#{DateTime.now}.csv" }
    end
  end

  def vh2unitytbl
    @pgtitle = "Unity 2000"
    @tcount = Book.all.where("title like ?", "%Unity 2000%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%Unity 2000%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vh2xomanowar
    @pgtitle = "X-O Manowar"
    @tcount = Book.where("title like ?", "%X-O Manowar%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%X-O Manowar%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%X-O Manowar%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "xomanowar-#{DateTime.now}.csv" }
    end
  end

  def vh2xomanowartbl
    @pgtitle = "X-O Manowar"
    @tcount = Book.all.where("title like ?", "%X-O Manowar%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").count
    @book = Book.where("title like ?", "%X-O Manowar%").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").where.not("note like ?", "%Sketch cover%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def baywatch
    @pgtitle = "Baywatch"
    @tcount = Book.where("title like ?", "%Baywatch%").count
    @book = Book.where("title like ?", "%Baywatch%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Baywatch").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "baywatch-#{DateTime.now}.csv" }
    end
  end

  def magic
    @pgtitle = "Magic: The Gathering"
    @tcount = Book.where("title like ?", "%Magic: The Gathering%").count
    @book = Book.where("title like ?", "%Magic: The Gathering%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Magic: The Gathering%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "magicthegathering-#{DateTime.now}.csv" }
    end
  end

  def sliders
    @pgtitle = "Sliders"
    @tcount = Book.where("title like ?", "%Sliders%").count
    @book = Book.where("title like ?", "%Sliders%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Sliders%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "sliders-#{DateTime.now}.csv" }
    end
  end

  def armeddangerous
    @pgtitle = "Armed & Dangerous"
    @tcount = Book.where("title like ?", "%Armed%").count
    @book = Book.where("title like ?", "%Armed%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Armed%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "armeddangerous-#{DateTime.now}.csv" }
    end
  end

  def grackle
    @pgtitle = "Grackle"
    @tcount = Book.where("title like ?", "%Grackle%").count
    @book = Book.where("title like ?", "%Grackle%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Grackle%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "grackle-#{DateTime.now}.csv" }
    end
  end

  def gravediggers
    @pgtitle = "Gravediggers"
    @tcount = Book.where("title like ?", "%Gravediggers%").count
    @book = Book.where("title like ?", "%Gravediggers%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Gravediggers%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "gravediggers-#{DateTime.now}.csv" }
    end
  end

  def captainn
    @pgtitle = "Captain N"
    @tcount = Book.where("title like ?", "%Captain N%").count
    @book = Book.where("title like ?", "%Captain N%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Captain N%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "captainn-#{DateTime.now}.csv" }
    end
  end

  def gameboy
    @pgtitle = "Game Boy"
    @tcount = Book.where("title like ?", "%Game Boy%").count
    @book = Book.where("title like ?", "%Game Boy%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Game Boy%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "gameboy-#{DateTime.now}.csv" }
    end
  end

  def nintendo
    @pgtitle = "Nintendo Game System"
    @tcount = Book.where("title like ?", "%Nintendo%").count
    @book = Book.where("title like ?", "%Nintendo%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Nintendo%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "nintendo-#{DateTime.now}.csv" }
    end
  end

  def mario
    @pgtitle = "Super Marios Bros"
    @tcount = Book.where("title like ?", "%Mario%").count
    @book = Book.where("title like ?", "%Mario%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Mario%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "supermariobros-#{DateTime.now}.csv" }
    end
  end

  def zelda
    @pgtitle = "Legends of Zelda"
    @tcount = Book.where("title like ?", "%Zelda%").count
    @book = Book.where("title like ?", "%Zelda%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Zelda%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "zelda-#{DateTime.now}.csv" }
    end
  end

  def barsinister
    @pgtitle = "Bar Sinister"
    @tcount = Book.where("title like ?", "%Bar Sinister%").count
    @book = Book.where("title like ?", "%Bar Sinister%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Bar Sinister%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "barsinister-#{DateTime.now}.csv" }
    end
  end

  def knighthawk
    @pgtitle = "Knighthawk"
    @tcount = Book.where("title like ?", "%Knighthawk%").count
    @book = Book.where("title like ?", "%Knighthawk%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Knighthawk%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "knighthawk-#{DateTime.now}.csv" }
    end
  end

  def samuree
    @pgtitle = "Samuree"
    @tcount = Book.where("title like ?", "%Samuree%").count
    @book = Book.where("title like ?", "%Samuree%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Samuree%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "samuree-#{DateTime.now}.csv" }
    end
  end

  def starslayer
    @pgtitle = "Starslayer"
    @tcount = Book.where("title like ?", "%Starslayer%").count
    @book = Book.where("title like ?", "%Starslayer%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%Starslayer%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "starslayer-#{DateTime.now}.csv" }
    end
  end

  def wwf
    @pgtitle = "WWF"
    @tcount = Book.where("title like ?", "%WWF%").count
    @book = Book.where("title like ?", "%WWF%").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    @bookcsv = Book.where("title like ?", "%WWF%").order(title: :asc, rdate: :asc, created_at: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "wwf-#{DateTime.now}.csv" }
    end
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def set_title
      @title = Book.find(params[:title])
    end

    def authenticate
      authenticate_or_request_with_http_basic('Administration') do |username, password|
        md5_of_password = Digest::MD5.hexdigest(password)
        username == 'admin' && md5_of_password == 'f08e6fa76f8883515f087b8b46208975'
      end
    end

    def csvauthenticate
      case request.format
      when Mime::XML
        authenticate_or_request_with_http_basic('Administration') do |username, password|
          md5_of_password = Digest::MD5.hexdigest(password)
          username == 'admin' && md5_of_password == 'f08e6fa76f8883515f087b8b46208975'
        end
      end
    end

    # new method added below
    def save_previews images
      if images
        images.each_value { |image|
        @book.previews.create(image: image)
        }
      end
    end

    def compare_previews images
      if images.presence
        images.each { |key,new_image|
          if @book.previews[key.to_i].presence 
            @book.previews[key.to_i].image = new_image
            @book.previews[key.to_i].save
          else
            @book.previews.create(image: new_image)
          end
        }
      end
    end

    def book_params
      params.require(:book).permit(:issue, :title, :rdate, :note, :image, :writer, :writer2, :artist, :artist2, :colors, :letters, :editor, :eic, :cover, :isb, :link, :arc, :summary, :bookcode, :qr, :price, :price_in_dollars, :pricenm, :value_in_dollars, :price98, :printrun, :category, :status, :event, :eventpart, :iskey, :keynote, :previews, :era, :country, :publisher, :printing, :tag_list)
    end
end
