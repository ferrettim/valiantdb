  require 'digest'
  require 'money'
  require 'money/bank/google_currency'

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
    @feed_posts = Book.all.where(:publisher => "Valiant Entertainment").where(:status => "Active").order(created_at: :desc).limit(10)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  def allfeed
    @feed_posts = Book.all.where(:publisher => "Valiant Entertainment").where(:status => "Active").order(created_at: :desc).limit(10)
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
      elsif params[:publisher].present?
        @book = @user.wished_books.where(:publisher => params[:publisher]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.wished_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.wished_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.wished_books.where.not(:country => "United States")
        @bookfourfiveone = @user.wished_books.where(:publisher => "451")
        @bookaftershock = @user.wished_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.wished_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.wished_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.wished_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.wished_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.wished_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.wished_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.wished_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.wished_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.wished_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.wished_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.wished_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.wished_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.wished_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.wished_books.where(:publisher => "Zenescope Entertainment")
      elsif params[:title].present?
        @book = @user.wished_books.where(:title => params[:title]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.wished_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.wished_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.wished_books.where.not(:country => "United States")
        @bookfourfiveone = @user.wished_books.where(:publisher => "451")
        @bookaftershock = @user.wished_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.wished_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.wished_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.wished_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.wished_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.wished_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.wished_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.wished_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.wished_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.wished_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.wished_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.wished_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.wished_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.wished_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.wished_books.where(:publisher => "Zenescope Entertainment")
      else
        @book = @user.wished_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.wished_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.wished_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.wished_books.where.not(:country => "United States")
        @bookfourfiveone = @user.wished_books.where(:publisher => "451")
        @bookaftershock = @user.wished_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.wished_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.wished_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.wished_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.wished_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.wished_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.wished_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.wished_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.wished_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.wished_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.wished_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.wished_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.wished_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.wished_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.wished_books.where(:publisher => "Zenescope Entertainment")
      end
      @bookcsv = @user.wished_books.order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "wishlist-#{Date.today}.csv" }
      end
  end

  def mywishlisttbl
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Collection"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Wishlist"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Wishlist"
    end
      if params[:query].present?
        @book = @user.wished_books.where(:title => params[:query]).page(params[:page]).per(24)
      elsif params[:publisher].present?
        @book = @user.wished_books.where(:publisher => params[:publisher]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.wished_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.wished_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.wished_books.where.not(:country => "United States")
        @bookfourfiveone = @user.wished_books.where(:publisher => "451")
        @bookaftershock = @user.wished_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.wished_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.wished_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.wished_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.wished_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.wished_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.wished_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.wished_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.wished_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.wished_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.wished_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.wished_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.wished_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.wished_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.wished_books.where(:publisher => "Zenescope Entertainment")
      elsif params[:title].present?
        @book = @user.wished_books.where(:title => params[:title]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.wished_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.wished_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.wished_books.where.not(:country => "United States")
        @bookfourfiveone = @user.wished_books.where(:publisher => "451")
        @bookaftershock = @user.wished_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.wished_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.wished_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.wished_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.wished_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.wished_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.wished_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.wished_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.wished_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.wished_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.wished_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.wished_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.wished_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.wished_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.wished_books.where(:publisher => "Zenescope Entertainment")
      else
        @book = @user.wished_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.wished_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.wished_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.wished_books.where.not(:country => "United States")
        @bookfourfiveone = @user.wished_books.where(:publisher => "451")
        @bookaftershock = @user.wished_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.wished_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.wished_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.wished_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.wished_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.wished_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.wished_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.wished_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.wished_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.wished_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.wished_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.wished_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.wished_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.wished_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.wished_books.where(:publisher => "Zenescope Entertainment")
      end
      @bookcsv = @user.wished_books.order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "wishlist-#{Date.today}.csv" }
      end
  end

  def mywishlistint
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
        @book = @user.wished_books.where.not(:country => "United States").order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.wished_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.wished_books.where(:era => "VH1")
        @bookvh2 = @user.wished_books.where(:era => "VH2")
        @bookint = @user.wished_books.where.not(:country => "United States")
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
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Books For Sale"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Sell List"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Sell List"
    end
      if params[:query].present?
        @book = @user.forsale_books.where(:title => params[:query]).page(params[:page]).per(24)
      elsif params[:publisher].present?
        @book = @user.forsale_books.where(:publisher => params[:publisher]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.forsale_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.forsale_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.forsale_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.forsale_books.where.not(:country => "United States")
        @bookfourfiveone = @user.forsale_books.where(:publisher => "451")
        @bookaftershock = @user.forsale_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.forsale_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.forsale_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.forsale_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.forsale_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.forsale_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.forsale_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.forsale_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.forsale_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.forsale_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.forsale_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.forsale_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.forsale_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.forsale_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.forsale_books.where(:publisher => "Zenescope Entertainment")
      elsif params[:title].present?
        @book = @user.forsale_books.where(:title => params[:title]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.forsale_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.forsale_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.forsale_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.forsale_books.where.not(:country => "United States")
        @bookfourfiveone = @user.forsale_books.where(:publisher => "451")
        @bookaftershock = @user.forsale_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.forsale_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.forsale_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.forsale_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.forsale_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.forsale_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.forsale_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.forsale_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.forsale_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.forsale_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.forsale_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.forsale_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.forsale_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.forsale_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.forsale_books.where(:publisher => "Zenescope Entertainment")
      else
        @book = @user.forsale_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.forsale_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.forsale_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.forsale_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.forsale_books.where.not(:country => "United States")
        @bookfourfiveone = @user.forsale_books.where(:publisher => "451")
        @bookaftershock = @user.forsale_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.forsale_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.forsale_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.forsale_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.forsale_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.forsale_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.forsale_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.forsale_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.forsale_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.forsale_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.forsale_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.forsale_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.forsale_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.forsale_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.forsale_books.where(:publisher => "Zenescope Entertainment")
      end
        @bookcsv = @user.forsale_books.order(title: :asc, rdate: :asc)
          respond_to do |format|
          format.html
          format.json { render json: @book }
          format.js
          format.csv { send_data @bookcsv.to_csv, filename: "forsale-#{Date.today}.csv" }
        end
      
  end

  def forsaletbl
    @user = User.friendly.find(params[:id])
    if user_signed_in?
      if @user == current_user
        @pgtitle = "My Books For Sale"
      else 
        @pgtitle = "#{User.friendly.find(params[:id]).name} 's Sell List"
      end
    else
      @pgtitle = "#{User.friendly.find(params[:id]).name}'s Sell List"
    end
      if params[:query].present?
        @book = @user.forsale_books.where(:title => params[:query]).page(params[:page]).per(24)
      elsif params[:publisher].present?
        @book = @user.forsale_books.where(:publisher => params[:publisher]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.forsale_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.forsale_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.forsale_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.forsale_books.where.not(:country => "United States")
        @bookfourfiveone = @user.forsale_books.where(:publisher => "451")
        @bookaftershock = @user.forsale_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.forsale_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.forsale_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.forsale_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.forsale_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.forsale_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.forsale_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.forsale_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.forsale_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.forsale_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.forsale_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.forsale_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.forsale_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.forsale_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.forsale_books.where(:publisher => "Zenescope Entertainment")
      elsif params[:title].present?
        @book = @user.forsale_books.where(:title => params[:title]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.forsale_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.forsale_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.forsale_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.forsale_books.where.not(:country => "United States")
        @bookfourfiveone = @user.forsale_books.where(:publisher => "451")
        @bookaftershock = @user.forsale_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.forsale_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.forsale_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.forsale_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.forsale_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.forsale_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.forsale_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.forsale_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.forsale_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.forsale_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.forsale_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.forsale_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.forsale_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.forsale_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.forsale_books.where(:publisher => "Zenescope Entertainment")
      else
        @book = @user.forsale_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.forsale_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.forsale_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.forsale_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.forsale_books.where.not(:country => "United States")
        @bookfourfiveone = @user.forsale_books.where(:publisher => "451")
        @bookaftershock = @user.forsale_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.forsale_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.forsale_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.forsale_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.forsale_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.forsale_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.forsale_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.forsale_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.forsale_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.forsale_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.forsale_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.forsale_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.forsale_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.forsale_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.forsale_books.where(:publisher => "Zenescope Entertainment")
      end
        @bookcsv = @user.forsale_books.order(title: :asc, rdate: :asc)
          respond_to do |format|
          format.html
          format.json { render json: @book }
          format.js
          format.csv { send_data @bookcsv.to_csv, filename: "forsale-#{Date.today}.csv" }
        end 
  end

  def monthlysales
    if params[:date].present?
      @date = Date.strptime(params[:date], '%m-%Y')
      @pgtitle = "Monthly Sales for " + Date.parse(@date.to_s).strftime("%B %Y")
      @booksales = Book.where(:category => "Default").where(:rdate => @date.beginning_of_month..@date.end_of_month).where("printrun > ?", "1").order(printrun: :desc).limit(300)   
    else
      @date = DateTime.now.strftime("%B %Y")
      @pgtitle = "Monthly Sales for " + DateTime.now.strftime("%B %Y")
      @booksales = Book.where(:category => "Default").where(:rdate => DateTime.now.beginning_of_month..DateTime.now.end_of_month).where("printrun > ?", "1").order(printrun: :desc).limit(300)
    end
  end

  def yearlysales
    if params[:date].present?
      @date = Date.strptime(params[:date], '%Y')
      @pgtitle = "Top Sellers for " + Date.parse(@date.to_s).strftime("%Y")
      @booksales = Book.where(:category => "Default").where(:rdate => @date.beginning_of_year..@date.end_of_year).where("printrun > ?", "1").order(printrun: :desc).limit(300)   
    else
      @date = DateTime.now.strftime("%Y")
      @pgtitle = "Top Sellers for " + DateTime.now.strftime("%Y")
      @booksales = Book.where(:category => "Default").where(:rdate => DateTime.now.beginning_of_year..DateTime.now.end_of_year).where("printrun > ?", "1").order(printrun: :desc).limit(300)
    end
  end

  def valiantvalues
    @pgtitle = "Valiant Books Ranked By Value"
    @book = Book.where.not(:category => "Sketch").where.not(:category => "Paperback").where.not(:category => "Hardcover").where("pricenm > ?", "0").order(pricenm: :desc).page(params[:page]).per(24)
  end 

  def valianttopvalues
    @pgtitle = "Top Valiant Comics Books By Value"
  end

  def valiantsalesvei
    @pgtitle = "Valiant Comics Sales by issue"
    @book = Book.all.where(:publisher => "Valiant Entertainment").where("printrun > ?", "1").order(printrun: :desc).page(params[:page]).per(24)
    @bookcsv = Book.all.where(:publisher => "Valiant Entertainment").where("printrun > ?", "1").order(printrun: :desc).limit(100)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.csv { send_data @bookcsv.to_csv, filename: "printruns-vei-#{DateTime.now}.csv" }
    end
  end

  def valiantsalestitle
    @pgtitle = "Valiant Comics Sales by title"
    @book = Book.where(:category => "Default").where(:rdate => (Date.today - 12.month)..(Date.today)).where("printrun > ?", "1").select("DISTINCT(title)").group("title").order("title")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.csv { send_data @bookcsv.super_csv, filename: "printruns-vei-#{DateTime.now}.csv" }
    end
  end

  def valiantsalesstats
    @pgtitle = "Valiant Comics Sales Statistics"
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantsalesstatstitle
    @pgtitle = "Valiant Comics Title Sales"
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valianttopselling
    @pgtitle = "Valiant Comics Top Selling Books"
    respond_to do |format|
      format.html
      format.json { render json: @books }
      format.js
    end
  end

  def thisweek
    @skip_footer = true
    @newbooks = Book.where(:publisher => "Valiant Entertainment").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).where.not(:category => "Sketch").order(:title).limit(15)
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
    end
  end

  def currentweek
    if params[:publisher].present?
      if params[:publisher] == "Aftershock Comics"
        @pgtitle = "Aftershock Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Aftershock Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "451"
        @pgtitle = "451 Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "451").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Archie Comics"
        @pgtitle = "Archie Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Archie Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Aspen Comics"
        @pgtitle = "Aspen Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Aspen COmics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Avatar Press"
        @pgtitle = "Avatar Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Avatar Press").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Boom Studios"
        @pgtitle = "Boom Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Boom Studios").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Black Mask Studios"
        @pgtitle = "Black Mask Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Black Mask Studios").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Dark Horse Comics"
        @pgtitle = "Dark Horse Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Dark Horse Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "DC Comics"
        @pgtitle = "DC Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "DC Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Dynamite Entertainment"
        @pgtitle = "Dynamite Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Dynamite Entertainment").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "IDW Publishing"
        @pgtitle = "IDW Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "IDW Publishing").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Marvel Comics"
        @pgtitle = "Marvel Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Marvel Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Image Comics"
        @pgtitle = "Image Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Image Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Valiant Entertainment"
        @pgtitle = "Valiant Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Valiant Entertainment").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Vertigo Comics"
        @pgtitle = "Vertigo Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Vertigo Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Zenescope Entertainment"
        @pgtitle = "Zenescope Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Zenescope Entertainment").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      end
    else
      @pgtitle = "Comics Releases for " + (Date.today.beginning_of_week + 2.day).strftime("%B %d, %Y")
      @newbooks = Book.where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
    end
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
    end
  end

  def nextweek
    if params[:publisher].present?
      if params[:publisher] == "Aftershock Comics"
        @pgtitle = "Aftershock Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Aftershock Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "451"
        @pgtitle = "451 Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "451").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Archie Comics"
        @pgtitle = "Archie Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Archie Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Aspen Comics"
        @pgtitle = "Aspen Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Aspen COmics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Avatar Press"
        @pgtitle = "Avatar Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Avatar Press").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Boom Studios"
        @pgtitle = "Boom Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Boom Studios").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Black Mask Studios"
        @pgtitle = "Black Mask Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Black Mask Studios").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Dark Horse Comics"
        @pgtitle = "Dark Horse Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Dark Horse Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "DC Comics"
        @pgtitle = "DC Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "DC Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Dynamite Entertainment"
        @pgtitle = "Dynamite Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Dynamite Entertainment").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "IDW Publishing"
        @pgtitle = "IDW Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "IDW Publishing").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Marvel Comics"
        @pgtitle = "Marvel Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Marvel Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Image Comics"
        @pgtitle = "Image Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Image Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Valiant Entertainment"
        @pgtitle = "Valiant Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Valiant Entertainment").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Vertigo Comics"
        @pgtitle = "Vertigo Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Vertigo Comics").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      elsif params[:publisher] == "Zenescope Entertainment"
        @pgtitle = "Zenescope Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
        @newbooks = Book.where(:publisher => "Zenescope Entertainment").where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_week..Date.today.end_of_week).order(:title)
      end
    else
      @pgtitle = "Comics Releases for " + (Date.today.beginning_of_week + 9.day).strftime("%B %d, %Y")
      @newbooks = Book.where.not("note like ?", "%Sketch cover%").where.not(:category => "Sketch").where(:rdate => (Date.today.beginning_of_week + 1.week)..(Date.today.end_of_week + 1.week)).order(:title)
    end
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
    end
  end

  def solicitations
    if params[:date].present?
      @date = Date.strptime(params[:date], '%m-%Y')
      @pgtitle = "Releases for " + Date.parse(@date.to_s).strftime("%B %Y")
      @newbooks = Book.where(:rdate => @date.beginning_of_month..@date.end_of_month).order(:rdate, :title)
      if params[:publisher].present?
        @date = Date.strptime(params[:date], '%m-%Y')
        @pgtitle = "Releases for " + Date.parse(@date.to_s).strftime("%B %Y")
        @newbooks = Book.where(:rdate => @date.beginning_of_month..@date.end_of_month).where(:publisher => params[:publisher]).where.not(:category => "Sketch").order(:rdate, :title)
      end    
    else
        @pgtitle = "Comic Releases for " + DateTime.now.strftime("%B %Y")
        @newbooks = Book.where.not(:category => "Sketch").where(:rdate => Date.today.beginning_of_month..Date.today.end_of_month).order(:rdate, :title)
    end
    respond_to do |format|
      format.html
      format.json { render json: @newbooks }
      format.js
      format.csv { send_data @newbooks.to_csv, filename: "releases-#{DateTime.now.strftime("%B-%Y")}.csv" }
    end
  end

  def valiantvh1releasedate
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

  def valiantvh1releasedatetbl
    @pgtitle = "Classic Valiant by release date"
    @book = Book.where.not(:category => "Sketch").where.not(:era => "Nintendo").where.not(:era => "Wrestling").where("rdate > ?", "1991-04-30").where("rdate < ?", "1996-09-30").order(rdate: :asc, title: :desc).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantvh2releasedate
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

  def valiantvh2releasedatetbl
    @pgtitle = "Acclaim by release date"
    @book = Book.where.not(:category => "Sketch").where.not(:era => "Armada").where.not(:era => "Crime").where.not(:era => "Windjammer").where("rdate > ?", "1996-09-30").where("rdate < ?", "2004-12-31").order(rdate: :asc, title: :desc).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantreleasedate
    @pgtitle = "Current Valiant by release date"
    @book = Book.where.not(:category => "Sketch").where("note like ?", "%Regular edition").where(:publisher => "Valiant Entertainment").order(rdate: :asc, title: :desc).page(params[:page]).per(24)
    @bookcsv = Book.where.not(:category => "Sketch").where("note like ?", "%Regular edition").where(:publisher => "Valiant Entertainment").order(rdate: :asc, title: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.to_csv, filename: "vei-releases-bydate.csv" }
    end
  end

  def valiantreleasedatetbl
    @pgtitle = "Current Valiant by release date"
    @book = Book.where.not(:category => "Sketch").where("note like ?", "%Regular edition%").where(:publisher => "Valiant Entertainment").order(rdate: :asc, title: :desc).page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantpubvei
    @pgtitle = "Vailant Comics Timeline (2012-)"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def valiantpubvh1
    @pgtitle = "Valiant Comics Timeline (1991-1996)"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def valianttimelinevh1
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
    Money.default_bank = Money::Bank::GoogleCurrency.new
    @variants = Book.where(:title => @book.title).where(:issue => @book.issue).where(rdate: (@book.rdate - 1.month)..(@book.rdate + 5.month)).where(:category => "Variant").where.not(:id => @book.id)
    @defaults = (Book.where(:title => @book.title).where(:issue => @book.issue).where(:category => "Default").where(rdate: (@book.rdate - 5.month)..(@book.rdate + 1.month)).where.not(:id => @book.id))
    @intrade = Book.where(:title => @book.title, :arc => @book.arc, :category => "Paperback")
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
    @book = Book.friendly.find(params[:id])
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
      elsif params[:publisher].present?
        @book = @user.owned_books.where(:publisher => params[:publisher]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.owned_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.owned_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.owned_books.where.not(:country => "United States")
        @bookfourfiveone = @user.owned_books.where(:publisher => "451")
        @bookaftershock = @user.owned_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.owned_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.owned_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.owned_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.owned_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.owned_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.owned_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.owned_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.owned_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.owned_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.owned_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.owned_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.owned_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.owned_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.owned_books.where(:publisher => "Zenescope Entertainment")
      elsif params[:title].present?
        @book = @user.owned_books.where(:title => params[:title]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.owned_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.owned_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.owned_books.where.not(:country => "United States")
        @bookfourfiveone = @user.owned_books.where(:publisher => "451")
        @bookaftershock = @user.owned_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.owned_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.owned_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.owned_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.owned_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.owned_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.owned_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.owned_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.owned_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.owned_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.owned_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.owned_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.owned_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.owned_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.owned_books.where(:publisher => "Zenescope Entertainment")
      else
        @book = @user.owned_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.owned_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.owned_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.owned_books.where.not(:country => "United States")
        @bookfourfiveone = @user.owned_books.where(:publisher => "451")
        @bookaftershock = @user.owned_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.owned_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.owned_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.owned_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.owned_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.owned_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.owned_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.owned_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.owned_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.owned_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.owned_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.owned_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.owned_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.owned_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.owned_books.where(:publisher => "Zenescope Entertainment")
      end
        @bookcsv = @user.owned_books.order(title: :asc, rdate: :asc)
          respond_to do |format|
          format.html
          format.json { render json: @book }
          format.js
          format.csv { send_data @bookcsv.to_csv, filename: "collection-#{Date.today}.csv" }
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
      elsif params[:publisher].present?
        @book = @user.owned_books.where(:publisher => params[:publisher]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.owned_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.owned_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.owned_books.where.not(:country => "United States")
        @bookfourfiveone = @user.owned_books.where(:publisher => "451")
        @bookaftershock = @user.owned_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.owned_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.owned_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.owned_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.owned_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.owned_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.owned_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.owned_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.owned_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.owned_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.owned_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.owned_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.owned_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.owned_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.owned_books.where(:publisher => "Zenescope Entertainment")
      elsif params[:title].present?
        @book = @user.owned_books.where(:title => params[:title]).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.owned_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.owned_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.owned_books.where.not(:country => "United States")
        @bookfourfiveone = @user.owned_books.where(:publisher => "451")
        @bookaftershock = @user.owned_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.owned_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.owned_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.owned_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.owned_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.owned_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.owned_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.owned_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.owned_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.owned_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.owned_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.owned_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.owned_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.owned_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.owned_books.where(:publisher => "Zenescope Entertainment")
      else
        @book = @user.owned_books.order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.owned_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.owned_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.owned_books.where.not(:country => "United States")
        @bookfourfiveone = @user.owned_books.where(:publisher => "451")
        @bookaftershock = @user.owned_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.owned_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.owned_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.owned_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.owned_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.owned_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.owned_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.owned_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.owned_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.owned_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.owned_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.owned_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.owned_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.owned_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.owned_books.where(:publisher => "Zenescope Entertainment")
      end
      @bookcsv = @user.owned_books.order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "collection-#{Date.today}.csv" }
      end
  end 

  def mybooksint
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
        @book = @user.owned_books.where(:title => params[:query]).where.not(:country => "United States").page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.owned_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.owned_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.owned_books.where.not(:country => "United States")
        @bookfourfiveone = @user.owned_books.where(:publisher => "451")
        @bookaftershock = @user.owned_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.owned_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.owned_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.owned_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.owned_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.owned_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.owned_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.owned_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.owned_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.owned_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.owned_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.owned_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.owned_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.owned_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.owned_books.where(:publisher => "Zenescope Entertainment")
      else
        @book = @user.owned_books.where.not(:country => "United States").order(title: :asc, rdate: :asc).page(params[:page]).per(24)
        @bookvei = @user.owned_books.where(:publisher => "Valiant Entertainment")
        @bookvh1 = @user.owned_books.where(:publisher => "Voyager Communications")
        @bookvh2 = @user.owned_books.where(:publisher => "Acclaim Entertainment")
        @bookint = @user.owned_books.where.not(:country => "United States")
        @bookfourfiveone = @user.owned_books.where(:publisher => "451")
        @bookaftershock = @user.owned_books.where(:publisher => "Aftershock Comics")
        @bookarchie = @user.owned_books.where(:publisher => "Archie Comics")
        @bookaspen = @user.owned_books.where(:publisher => "Aspen Comics")
        @bookavatar = @user.owned_books.where(:publisher => "Avatar Press")
        @bookblackmask = @user.owned_books.where(:publisher => "Black Mask Studios")
        @bookboom = @user.owned_books.where(:publisher => "Boom Studios")
        @bookdarkhorse = @user.owned_books.where(:publisher => "Dark Horse Comics")
        @bookdc = @user.owned_books.where(:publisher => "DC Comics")
        @bookdynamite = @user.owned_books.where(:publisher => "Dynamite Entertainment")
        @bookidw = @user.owned_books.where(:publisher => "IDW Publishing")
        @bookimage = @user.owned_books.where(:publisher => "Image Comics")
        @bookmarvel = @user.owned_books.where(:publisher => "Marvel Comics")
        @booktopshelf = @user.owned_books.where(:publisher => "Top Shelf Productions")
        @bookvertigo = @user.owned_books.where(:publisher => "Vertigo Comics")
        @bookzenescope = @user.owned_books.where(:publisher => "Zenescope Entertainment")
      end 
      @bookcsv = @user.owned_books.where(:era => "VH2").order(title: :asc, rdate: :asc)
      respond_to do |format|
        format.html
        format.json { render json: @book }
        format.js
        format.csv { send_data @bookcsv.to_csv, filename: "international-valiant-collection-#{Date.today}.csv" }
      end
  end  

  # EVENTS
  def valiantevent4001ad
    @pgtitle = "4001 A.D. Reading Order"
    @books = Book.where(:event => "4001 A.D.").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def valianteventshw
    @pgtitle = "Harbinger Wars Reading Order"
    @books = Book.where(:event => "Harbinger Wars").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def valianteventsah
    @pgtitle = "Armor Hunters Readering Order"
    @books = Book.where(:event => "Armor Hunters").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def valianteventsbod
    @pgtitle = "Book of Death Reading Order"
    @books = Book.where(:event => "Book of Death").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

   def valianteventschaoseffect
    @pgtitle = "Chaos Effect"
    @books = Book.where(:event => "Chaos Effect").order(eventpart: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def valianteventsunity
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

  def valiantbrazil
    @pgtitle = "Brazil"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Brazil").count
    if params[:type].present?
      @book = Book.all.where(:country => "Brazil").where(:category => params[:type]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Brazil").where(:category => params[:type]).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Brazil").where(:issue => params[:number]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Brazil").where(:issue => params[:number]).count
    else
      @tcount = Book.all.where(:country => "Brazil").count
      @book = Book.all.where(:country => "Brazil").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Brazil").order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allbrazil-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantbraziltbl
    @pgtitle = "Brazil"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Brazil").count
      @book = Book.all.where(:category => params[:type]).where(:country => "Brazil").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Brazil").count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Brazil").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Brazil").count
      @book = Book.all.where(:country => "Brazil").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantbrazilmissing
    @pgtitle = "Brazil (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Brazil").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:country => "Brazil").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Brazil").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Brazil").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Brazil").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:country => "Brazil").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Brazil").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Brazil").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allbrazil-missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantbraziltblmissing
    @pgtitle = "Brazil (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Brazil").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:category => params[:type]).where(:country => "Brazil").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Brazil").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Brazil").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Brazil").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Brazil").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantcanada
    @pgtitle = "Canada"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Canada").count
    if params[:type].present?
      @book = Book.all.where(:country => "Canada").where(:category => params[:type]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Canada").where(:category => params[:type]).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Canada").where(:issue => params[:number]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Canada").where(:issue => params[:number]).count
    else
      @tcount = Book.all.where(:country => "Canada").count
      @book = Book.all.where(:country => "Canada").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Canada").order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allcanada-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantcanadatbl
    @pgtitle = "Canada"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Canada").count
      @book = Book.all.where(:category => params[:type]).where(:country => "Canada").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Canada").count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Canada").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Canada").count
      @book = Book.all.where(:country => "Canada").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantcanadamissing
    @pgtitle = "Canada (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Canada").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:country => "Canada").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Canada").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Canada").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Canada").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:country => "Canada").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Canada").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Canada").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allcanada-missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantcanadatblmissing
    @pgtitle = "Canada (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Canada").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:category => params[:type]).where(:country => "Canada").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Canada").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Canada").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Canada").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Canada").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantchina
    @pgtitle = "China"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "China").count
    if params[:type].present?
      @book = Book.all.where(:country => "China").where(:category => params[:type]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "China").where(:category => params[:type]).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "China").where(:issue => params[:number]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "China").where(:issue => params[:number]).count
    else
      @tcount = Book.all.where(:country => "China").count
      @book = Book.all.where(:country => "China").order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "China").order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allcurrent-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantchinatbl
    @pgtitle = "China"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "China").count
      @book = Book.all.where(:category => params[:type]).where(:country => "China").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "China").count
      @book = Book.all.where(:issue => params[:number]).where(:country => "China").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "China").count
      @book = Book.all.where(:country => "China").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantchinamissing
    @pgtitle = "China (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "China").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:country => "China").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "China").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "China").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "China").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:country => "China").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "China").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "China").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allchina-missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantchinatblmissing
    @pgtitle = "China (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "China").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:category => params[:type]).where(:country => "China").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "China").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:issue => params[:number]).where(:country => "China").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "China").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "China").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantfrance
    @pgtitle = "France"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "France").count
    if params[:type].present?
      @book = Book.all.where(:country => "France").where(:category => params[:type]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "France").where(:category => params[:type]).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "France").where(:issue => params[:number]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "France").where(:issue => params[:number]).count
    else
      @tcount = Book.all.where(:country => "France").count
      @book = Book.all.where(:country => "France").order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "France").order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allfrance-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantfrancetbl
    @pgtitle = "France"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "France").count
      @book = Book.all.where(:category => params[:type]).where(:country => "France").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "France").count
      @book = Book.all.where(:issue => params[:number]).where(:country => "France").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "France").count
      @book = Book.all.where(:country => "France").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantfrancemissing
    @pgtitle = "France (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "France").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:country => "France").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "France").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "France").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "France").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:country => "France").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "France").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "France").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allfrance-missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantfrancetblmissing
    @pgtitle = "France (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "France").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:category => params[:type]).where(:country => "France").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "France").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:issue => params[:number]).where(:country => "France").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "France").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "France").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantitaly
    @pgtitle = "Italy"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Italy").count
    if params[:type].present?
      @book = Book.all.where(:country => "Italy").where(:category => params[:type]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Italy").where(:category => params[:type]).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Italy").where(:issue => params[:number]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Italy").where(:issue => params[:number]).count
    else
      @tcount = Book.all.where(:country => "Italy").count
      @book = Book.all.where(:country => "Italy").order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Italy").order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allitaly-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantitalytbl
    @pgtitle = "Italy"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Italy").count
      @book = Book.all.where(:category => params[:type]).where(:country => "Italy").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Italy").count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Italy").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Italy").count
      @book = Book.all.where(:country => "Italy").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantitalymissing
    @pgtitle = "Italy (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Italy").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:country => "Italy").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Italy").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Italy").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Italy").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:country => "Italy").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Italy").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Italy").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allitaly-missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantitalytblmissing
    @pgtitle = "Italy (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Italy").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:category => params[:type]).where(:country => "Italy").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Italy").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Italy").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Italy").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Italy").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantjapan
    @pgtitle = "Japan"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Japan").count
    if params[:type].present?
      @book = Book.all.where(:country => "Japan").where(:category => params[:type]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Japan").where(:category => params[:type]).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Japan").where(:issue => params[:number]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Japan").where(:issue => params[:number]).count
    else
      @tcount = Book.all.where(:country => "Japan").count
      @book = Book.all.where(:country => "Japan").order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Japan").order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "alljapan-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantjapantbl
    @pgtitle = "Japan"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Japan").count
      @book = Book.all.where(:category => params[:type]).where(:country => "Japan").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Japan").count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Japan").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Japan").count
      @book = Book.all.where(:country => "Japan").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantjapanmissing
    @pgtitle = "Japan (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Japan").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:country => "Japan").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Japan").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Japan").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Japan").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:country => "Japan").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Japan").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Japan").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "alljapan-missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantjapantblmissing
    @pgtitle = "Japan (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Japan").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:category => params[:type]).where(:country => "Japan").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Japan").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Japan").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Japan").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Japan").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantmexico
    @pgtitle = "Mexico"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Mexico").count
    if params[:type].present?
      @book = Book.all.where(:country => "Mexico").where(:category => params[:type]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Mexico").where(:category => params[:type]).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Mexico").where(:issue => params[:number]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Mexico").where(:issue => params[:number]).count
    else
      @tcount = Book.all.where(:country => "Mexico").count
      @book = Book.all.where(:country => "Mexico").order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Mexico").order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allmexico-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantmexicotbl
    @pgtitle = "Mexico"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Mexico").count
      @book = Book.all.where(:category => params[:type]).where(:country => "Mexico").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Mexico").count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Mexico").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Mexico").count
      @book = Book.all.where(:country => "Mexico").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantmexicomissing
    @pgtitle = "Mexico (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Mexico").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:country => "Mexico").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Mexico").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Mexico").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Mexico").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:country => "Mexico").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Mexico").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Mexico").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allmexico-missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantmexicotblmissing
    @pgtitle = "Mexico (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Mexico").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:category => params[:type]).where(:country => "Mexico").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Mexico").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Mexico").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Mexico").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Mexico").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantrussia
    @pgtitle = "Russia"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Russia").count
    if params[:type].present?
      @book = Book.all.where(:country => "Russia").where(:category => params[:type]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Russia").where(:category => params[:type]).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Russia").where(:issue => params[:number]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Russia").where(:issue => params[:number]).count
    else
      @tcount = Book.all.where(:country => "Russia").count
      @book = Book.all.where(:country => "Russia").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Russia").order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allrussia-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantrussiatbl
    @pgtitle = "Russia"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Russia").count
      @book = Book.all.where(:category => params[:type]).where(:country => "Russia").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Russia").count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Russia").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Russia").count
      @book = Book.all.where(:country => "Russia").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantrussiamissing
    @pgtitle = "Russia (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Russia").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:country => "Russia").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Russia").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Russia").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Russia").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:country => "Russia").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Russia").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Russia").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allrussia-missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantrussiatblmissing
    @pgtitle = "Russia (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Russia").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:category => params[:type]).where(:country => "Russia").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Russia").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Russia").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Russia").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Russia").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantturkey
    @pgtitle = "Turkey"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Turkey").count
    if params[:type].present?
      @book = Book.all.where(:country => "Turkey").where(:category => params[:type]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Turkey").where(:category => params[:type]).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Turkey").where(:issue => params[:number]).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Turkey").where(:issue => params[:number]).count
    else
      @tcount = Book.all.where(:country => "Turkey").count
      @book = Book.all.where(:country => "Turkey").order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Turkey").order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allturkey-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantturkeytbl
    @pgtitle = "Turkey"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Turkey").count
      @book = Book.all.where(:category => params[:type]).where(:country => "Turkey").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Turkey").count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Turkey").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Turkey").count
      @book = Book.all.where(:country => "Turkey").order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantturkeymissing
    @pgtitle = "Turkey (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:country => "Turkey").where.not(id: current_user.owned_book_ids).count
    if params[:type].present?
      @book = Book.all.where(:country => "Turkey").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Turkey").where(:category => params[:type]).where.not(id: current_user.owned_book_ids).count
    elsif params[:number].present?
      @book = Book.all.where(:country => "Turkey").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
      @tcount = Book.all.where(:country => "Turkey").where(:issue => params[:number]).where.not(id: current_user.owned_book_ids).count
    else
      @tcount = Book.all.where(:country => "Turkey").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Turkey").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc).page(params[:page]).per(24)
    end
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:country => "Turkey").where.not(id: current_user.owned_book_ids).order(rdate: :asc, title: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allturkey-missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantturkeytblmissing
    @pgtitle = "Turkey (Missing)"
    if params[:type].present?
      @tcount = Book.all.where(:category => params[:type]).where(:country => "Turkey").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:category => params[:type]).where(:country => "Turkey").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    elsif params[:number].present?
      @tcount = Book.all.where(:issue => params[:number]).where(:country => "Turkey").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:issue => params[:number]).where(:country => "Turkey").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    else
      @tcount = Book.all.where(:country => "Turkey").where.not(id: current_user.owned_book_ids).count
      @book = Book.all.where(:country => "Turkey").where.not(id: current_user.owned_book_ids).order(title: :asc, rdate: :asc, created_at: :asc).page(params[:page]).per(24)
    end
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # 451
  def fourfiveoneall
    @pgtitle = "451"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "451").count
    @tcount = Book.all.where(:publisher => "451")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "451").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "451").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "451").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "451").select("DISTINCT(category)").group("category").order("category")       
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "451").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "all451-#{DateTime.now}.csv" }
    end
  end

  def fourfiveonealltbl
    @pgtitle = "451"
    @tcount = Book.all.where(:publisher => "451")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "451").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "451").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "451").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "451").select("DISTINCT(category)").group("category").order("category")  
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def fourfiveoneallmissing
    @pgtitle = "451 (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "451").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "451").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "451").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "451").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "451").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "451").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "451").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "all451missing-valiant-#{DateTime.now}.csv" }
    end
  end

  def fourfiveonealltblmissing
    @pgtitle = "451 (Missing)"
    @tcount = Book.all.where(:publisher => "451").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "451").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "451").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "451").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "451").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Aftershock
  def aftershockall
    @pgtitle = "Aftershock"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Aftershock Comics").count
    @tcount = Book.all.where(:publisher => "Aftershock Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Aftershock Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Aftershock Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allaftershock-#{DateTime.now}.csv" }
    end
  end

  def aftershockalltbl
    @pgtitle = "Aftershock"
    @tcount = Book.all.where(:publisher => "Aftershock Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Aftershock Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def aftershockallmissing
    @pgtitle = "Aftershock (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Aftershock Comics").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Aftershock Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Aftershock Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Aftershock Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allaftershockmissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def aftershockalltblmissing
    @pgtitle = "Aftershock (Missing)"
    @tcount = Book.all.where(:publisher => "Aftershock Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Aftershock Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Aftershock Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Archie
  def archieall
    @pgtitle = "Archie"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Archie Comics").count
    @tcount = Book.all.where(:publisher => "Archie Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Archie Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Archie Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Archie Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Archie Comics").select("DISTINCT(category)").group("category").order("category")       
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Archie Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allarchie-#{DateTime.now}.csv" }
    end
  end

  def archiealltbl
    @pgtitle = "Archie"
    @tcount = Book.all.where(:publisher => "Archie Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Archie Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Archie Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Archie Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Archie Comics").select("DISTINCT(category)").group("category").order("category") 
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def archieallmissing
    @pgtitle = "Archie (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Archie Comics").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Archie Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Archie Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Archie Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Archie Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Archie Comics").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Archie Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allarchiemissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def archiealltblmissing
    @pgtitle = "Archie (Missing)"
    @tcount = Book.all.where(:publisher => "Archie Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Archie Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Archie Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Archie Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Archie Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Aspen
  def aspenall
    @pgtitle = "Aspen All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Aspen Comics").count
    @tcount = Book.all.where(:publisher => "Aspen Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Aspen Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Aspen Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Aspen Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Aspen Comics").select("DISTINCT(category)").group("category").order("category")       
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Aspen Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allaspen-#{DateTime.now}.csv" }
    end
  end

  def aspenalltbl
    @pgtitle = "Aspen All"
    @tcount = Book.all.where(:publisher => "Aspen Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Aspen Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Aspen Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Aspen Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Aspen Comics").select("DISTINCT(category)").group("category").order("category")  
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def aspenallmissing
    @pgtitle = "Aspen (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Aspen Comics").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Aspen Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Aspen Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Aspen Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Aspen Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Aspen Comics").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Aspen Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allaspenmissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def aspenalltblmissing
    @pgtitle = "Aspen (Missing)"
    @tcount = Book.all.where(:publisher => "Aspen Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Aspen Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Aspen Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Aspen Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Aspen Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Avatar
  def avatarall
    @pgtitle = "Avatar All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Avatar Press").count
    @tcount = Book.all.where(:publisher => "Avatar Press")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Avatar Press").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Avatar Press").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Avatar Press").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Avatar Press").select("DISTINCT(category)").group("category").order("category")       
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Avatar Press").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allavatar-#{DateTime.now}.csv" }
    end
  end

  def avataralltbl
    @pgtitle = "Avatar All"
    @tcount = Book.all.where(:publisher => "Avatar Press")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Avatar Press").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Avatar Press").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Avatar Press").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Avatar Press").select("DISTINCT(category)").group("category").order("category") 
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def avatarallmissing
    @pgtitle = "Avatar (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Avatar Press").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Avatar Press").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Avatar Press").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Avatar Press").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Avatar press").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Avatar Press").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Avatar Press").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allavatarmissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def avataralltblmissing
    @pgtitle = "Avatar (Missing)"
    @tcount = Book.all.where(:publisher => "Avatar Press").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Avatar Press").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Avatar Press").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Avatar press").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Avatar Press").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Black Mask
  def blackmaskall
    @pgtitle = "Black Mask"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Black Mask Studios").count
    @tcount = Book.all.where(:publisher => "Black Mask Studios")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Black Mask Studios").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(category)").group("category").order("category")      
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Black Mask Studios").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allblackmask-#{DateTime.now}.csv" }
    end
  end

  def blackmaskalltbl
    @pgtitle = "Black Mask"
    @tcount = Book.all.where(:publisher => "Black Mask Studios")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Black Mask Studios").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(category)").group("category").order("category")  
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def blackmaskallmissing
    @pgtitle = "Black Mask (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Black Mask Studios").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Black Mask Studios").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Black Mask Studios").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Black Mask Studios").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allblackmaskmissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def blackmaskalltblmissing
    @pgtitle = "Black Mask (Missing)"
    @tcount = Book.all.where(:publisher => "Black Mask Studios").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Black Mask Studios").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Black Mask Studios").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Boom
  def boomall
    @pgtitle = "Boom All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Boom Studios").count
    @tcount = Book.all.where(:publisher => "Boom Studios")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Boom Studios").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Boom Studios").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Boom Studios").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Boom Studios").select("DISTINCT(category)").group("category").order("category")        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Boom Studios").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allboom-#{DateTime.now}.csv" }
    end
  end

  def boomalltbl
    @pgtitle = "Boom All"
    @tcount = Book.all.where(:publisher => "Boom Studios")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Boom Studios").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Boom Studios").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Boom Studios").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Boom Studios").select("DISTINCT(category)").group("category").order("category") 
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def boomallmissing
    @pgtitle = "Boom (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Boom Studios").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Boom Studios").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Boom Studios").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Boom Studios").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Boom Studios").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Boom Studios").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Boom Studios").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allboommissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def boomalltblmissing
    @pgtitle = "Boom (Missing)"
    @tcount = Book.all.where(:publisher => "Boom Studios").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Boom Studios").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Boom Studios").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Boom Studios").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Boom Studios").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Dark Horse
  def darkhorseall
    @pgtitle = "Dark Horse All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Dark Horse Comics").count
    @tcount = Book.all.where(:publisher => "Dark Horse Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Dark Horse Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(category)").group("category").order("category")        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Dark Horse Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "alldarkhorse-#{DateTime.now}.csv" }
    end
  end

  def darkhorsealltbl
    @pgtitle = "Dark Horse All"
    @tcount = Book.all.where(:publisher => "Dark Horse Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Dark Horse Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def darkhorseallmissing
    @pgtitle = "Dark Horse (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Dark Horse Comics").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Dark Horse Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Dark Horse Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Dark Horse Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "alldarkhorsemissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def darkhorsealltblmissing
    @pgtitle = "Dark Horse (Missing)"
    @tcount = Book.all.where(:publisher => "Dark Horse Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Dark Horse Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Dark Horse Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # DC
  def dcall
    @pgtitle = "DC All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "DC Comics").count
    @tcount = Book.all.where(:publisher => "DC Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "DC Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "DC Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "DC Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "DC Comics").select("DISTINCT(category)").group("category").order("category")
    @notowned = Book.where.not(Own.where("owns.book_id = books.id", "owns.user_id = current_user.id").limit(1).arel.exists).page(params[:page]).per(24)        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "DC Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "alldc-#{DateTime.now}.csv" }
    end
  end

  def dcalltbl
    @pgtitle = "DC All"
    @tcount = Book.all.where(:publisher => "DC Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "DC Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "DC Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "DC Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "DC Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def dcallmissing
    @pgtitle = "DC (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "DC Comics").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "DC Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "DC Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "DC Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "DC Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "DC Comics").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "DC Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "alldc-valiant-#{DateTime.now}.csv" }
    end
  end

  def dcalltblmissing
    @pgtitle = "DC (Missing)"
    @tcount = Book.all.where(:publisher => "DC Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "DC Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "DC Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "DC Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "DC Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Dynamite
  def dynamiteall
    @pgtitle = "Dynamite All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Dynamite Entertainment").count
    @tcount = Book.all.where(:publisher => "Dynamite Entertainment")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Dynamite Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(category)").group("category").order("category")       
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Dynamite Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "alldynamite-#{DateTime.now}.csv" }
    end
  end

  def dynamitealltbl
    @pgtitle = "Dynamite All"
    @tcount = Book.all.where(:publisher => "Dynamite Entertainment")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Dynamite Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(category)").group("category").order("category")  
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def dynamiteallmissing
    @pgtitle = "Dynamite (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Dynamite Entertainment").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Dynamite Entertainment").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Dynamite Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Dynamite Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "alldynamitemissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def dynamitealltblmissing
    @pgtitle = "Dynamite (Missing)"
    @tcount = Book.all.where(:publisher => "Dynamite Entertainment").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Dynamite Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Dynamite Entertainment").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # IDW
  def idwall
    @pgtitle = "IDW All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "IDW Publishing").count
    @tcount = Book.all.where(:publisher => "IDW Publishing")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "IDW Publishing").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "IDW Publishing").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "IDW Publishing").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "IDW Publishing").select("DISTINCT(category)").group("category").order("category")      
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "IDW Publishing").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allidw-#{DateTime.now}.csv" }
    end
  end

  def idwalltbl
    @pgtitle = "IDW All"
    @tcount = Book.all.where(:publisher => "IDW Publishing")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "IDW Publishing").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "IDW Publishing").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "IDW Publishing").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "IDW Publishing").select("DISTINCT(category)").group("category").order("category") 
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def idwallmissing
    @pgtitle = "IDW (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "IDW Publishing").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "IDW Publishing").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "IDW Publishing").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "IDW Publishing").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "IDW Publishing").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "IDW Publishing").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "IDW Publishing").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allidwmissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def idwtblmissing
    @pgtitle = "IDW (Missing)"
    @tcount = Book.all.where(:publisher => "IDW Publishing").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "IDW Publishing").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "IDW Publishing").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "IDW Publishing").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "IDW Publishing").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Image
  def imageall
    @pgtitle = "Image"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Image Comics").count
    @tcount = Book.all.where(:publisher => "Image Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Image Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Image Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Image Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Image Comics").select("DISTINCT(category)").group("category").order("category")      
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Image Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allimage-#{DateTime.now}.csv" }
    end
  end

  def imagealltbl
    @pgtitle = "Image"
    @tcount = Book.all.where(:publisher => "Image Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Image Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Image Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Image Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Image Comics").select("DISTINCT(category)").group("category").order("category") 
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def imageallmissing
    @pgtitle = "Image (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Image Comics").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Image Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Image Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Image Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Image Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Image Comics").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Image Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allimagemissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def imagealltblmissing
    @pgtitle = "Image (Missing)"
    @tcount = Book.all.where(:publisher => "Image Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Image Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Image Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Image Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Image Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Marvel
  def marvelall
    @pgtitle = "Marvel All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Marvel Comics").count
    @tcount = Book.all.where(:publisher => "Marvel Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Marvel Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Marvel Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Marvel Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Marvel Comics").select("DISTINCT(category)").group("category").order("category")        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Marvel Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allmarvel-#{DateTime.now}.csv" }
    end
  end

  def marvelalltbl
    @pgtitle = "Marvel All"
    @tcount = Book.all.where(:publisher => "Marvel Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Marvel Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Marvel Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Marvel Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Marvel Comics").select("DISTINCT(category)").group("category").order("category") 
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def marvelallmissing
    @pgtitle = "Marvel (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Marvel Comics").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Marvel Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Marvel Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Marvel Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Marvel Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Marvel Comics").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Marvel Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allmarvel-valiant-#{DateTime.now}.csv" }
    end
  end

  def marvelalltblmissing
    @pgtitle = "Marvel (Missing)"
    @tcount = Book.all.where(:publisher => "Marvel Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Marvel Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Marvel Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Marvel Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Marvel Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Vertigo
  def vertigoall
    @pgtitle = "Vertigo All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Vertigo Comics").count
    @tcount = Book.all.where(:publisher => "Vertigo Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Vertigo Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(category)").group("category").order("category")         
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Vertigo Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allvertigo-#{DateTime.now}.csv" }
    end
  end

  def vertigoalltbl
    @pgtitle = "Vertigo All"
    @tcount = Book.all.where(:publisher => "Vertigo Comics")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Vertigo Comics").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(category)").group("category").order("category") 
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def vertigoallmissing
    @pgtitle = "Vertigo (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Vertigo Comics").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Vertigo Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Vertigo Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Vertigo Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allvertigomissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def vertigoalltblmissing
    @pgtitle = "Vertigo (Missing)"
    @tcount = Book.all.where(:publisher => "Vertigo Comics").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Vertigo Comics").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Vertigo Comics").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # fcope
  def zenescopeall
    @pgtitle = "Zenescope All"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Zenescope Entertainment").count
    @tcount = Book.all.where(:publisher => "Zenescope Entertainment")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Zenescope Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(category)").group("category").order("category")        
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Zenescope Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allzenescope-#{DateTime.now}.csv" }
    end
  end

  def zenescopealltbl
    @pgtitle = "Zenescope All"
    @tcount = Book.all.where(:publisher => "Zenescope Entertainment")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Zenescope Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(category)").group("category").order("category") 
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def zenescopeallmissing
    @pgtitle = "Zenescope (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Zenescope Entertainment").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Zenescope Entertainment").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Zenescope Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Zenescope Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allzenescopemissing-valiant-#{DateTime.now}.csv" }
    end
  end

  def zenescopealltblmissing
    @pgtitle = "Zenescope (Missing)"
    @tcount = Book.all.where(:publisher => "Zenescope Entertainment").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Zenescope Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Zenescope Entertainment").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Valiant
  def valiantall
    @pgtitle = "Valiant"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Valiant Entertainment").count
    @tcount = Book.all.where(:publisher => "Valiant Entertainment")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Valiant Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(category)").group("category").order("category")      
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Valiant Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allcurrent-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantalltbl
    @pgtitle = "Valiant"
    @tcount = Book.all.where(:publisher => "Valiant Entertainment")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Valiant Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(category)").group("category").order("category")  
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantallmissing
    @pgtitle = "Valiant (Missing)"
    @search_count = Book.all.where(:category => params[:query]).where(:publisher => "Valiant Entertainment").where.not(id: current_user.owned_book_ids).count
    @tcount = Book.all.where(:publisher => "Valiant Entertainment").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Valiant Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.all.where("rdate < ?", Date.today).where(:publisher => "Valiant Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "allcurrent-valiant-#{DateTime.now}.csv" }
    end
  end

  def valiantalltblmissing
    @pgtitle = "Valiant (Missing)"
    @tcount = Book.all.where(:publisher => "Valiant Entertainment").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Valiant Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Valiant Entertainment").select("DISTINCT(category)").group("category").order("category")
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

  def valiantkeys
    @pgtitle = "Key Issues (2012-)"
    @books = Book.where(:iskey => true).where(:publisher => "Valiant Entertainment").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def valiantsketch
    @pgtitle = "Sketch Covers"
    @search_count = Book.where(:category => "Sketch").where(:cover => params[:query]).where(:publisher => "Valiant Entertainment")
    @tcount = Book.all.where(:category => "Sketch").where(:publisher => "Valiant Entertainment").where(status: "Active")
    @tcount = @tcount.where(:cover => params[:cover]) if params[:cover].present?
    @book = Book.all.where(:publisher => "Valiant Entertainment").where(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:cover => params[:cover]) if params[:cover].present?
    @optionscover = Book.where(:category => "Sketch").select("DISTINCT(cover)").group("cover").order("cover")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantsketchtbl
    @pgtitle = "Sketch Covers"
    @tcount = Book.all.where(:category => "Sketch").where(:publisher => "Valiant Entertainment").where(status: "Active")
    @tcount = @tcount.where(:cover => params[:cover]) if params[:cover].present?
    @book = Book.all.where(:publisher => "Valiant Entertainment").where(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:cover => params[:cover]) if params[:cover].present?
    @optionscover = Book.where(:category => "Sketch").select("DISTINCT(cover)").group("cover").order("cover")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Clasic Valiant
  def valiantvh1keys
    @pgtitle = "Key Issues (1991-1996)"
    @books = Book.where(:iskey => true).where("rdate < ?", "1996-09-30").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.js
    end
  end 

  def valiantvh1all
    @pgtitle = "Classic Valiant"
    @search_count = Book.where(:category => params[:query]).where(:era => "VH2").count
    @tcount = Book.all.where(:publisher => "Voyager Communications")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Voyager Communications").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Voyager Communications").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Voyager Communications").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Voyager Communications").select("DISTINCT(category)").group("category").order("category")  
    @bookcsv = Book.where(:era => "VH2").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "classicvaliantall-#{DateTime.now}.csv" }
    end
  end

  def valiantvh1alltbl
    @pgtitle = "Classic Valiant"
    @tcount = Book.all.where(:publisher => "Voyager Communications")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Voyager Communications").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Voyager Communications").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Voyager Communications").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Voyager Communications").select("DISTINCT(category)").group("category").order("category") 
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantvh1allmissing
    @pgtitle = "Classic Valiant (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where(:category => params[:query]).where(:era => "VH2").count
    @tcount = Book.all.where(:publisher => "Voyager Communications").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Voyager Communications").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Voyager Communications").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Voyager Communications").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Voyager Communications").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:era => "VH2").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "classicvaliantall-missing-#{DateTime.now}.csv" }
    end
  end

  def valiantvh1alltblmissing
    @pgtitle = "Classic Valiant (Missing)"
    @tcount = Book.all.where(:publisher => "Voyager Communications").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Voyager Communications").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Voyager Communications").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Voyager Communications").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Voyager Communications").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  # Acclaim
  def valiantvh2all
    @pgtitle = "Acclaim"
    @search_count = Book.where(:category => params[:query]).where(:era => "VH2").count
    @tcount = Book.all.where(:publisher => "Acclaim Entertainment")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Acclaim Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(category)").group("category").order("category")  
    @bookcsv = Book.where(:era => "VH2").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "acclaim-#{DateTime.now}.csv" }
    end
  end

  def valiantvh2alltbl
    @pgtitle = "Acclaim"
    @tcount = Book.all.where(:publisher => "Acclaim Entertainment")
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Acclaim Entertainment").where.not(:category => "Sketch").order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  def valiantvh2allmissing
    @pgtitle = "Acclaim (Missing)"
    @search_count = Book.where.not(id: current_user.owned_book_ids).where(:category => params[:query]).where(:era => "VH2").count
    @tcount = Book.all.where(:publisher => "Acclaim Entertainment").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Acclaim Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(category)").group("category").order("category")
    @bookcsv = Book.where.not(id: current_user.owned_book_ids).where(:era => "VH2").order(rdate: :asc, issue: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
      format.xml { send_data @bookcsv.super_csv, filename: "acclaim-missing-#{DateTime.now}.csv" }
    end
  end

  def valiantvh2alltblmissing
    @pgtitle = "Acclaim (Missing)"
    @tcount = Book.all.where(:publisher => "Acclaim Entertainment").where.not(id: current_user.owned_book_ids)
    @tcount = @tcount.where(:issue => params[:issue]) if params[:issue].present?
    @tcount = @tcount.where(:title => params[:title]) if params[:title].present?
    @book = Book.all.where(:publisher => "Acclaim Entertainment").where.not(:category => "Sketch").where.not(id: current_user.owned_book_ids).order(rdate: :asc, issue: :asc).page(params[:page]).per(24)
    @book = @book.where(:issue => params[:issue]) if params[:issue].present?
    @book = @book.where(:title => params[:title]) if params[:title].present?      
    @optionstitle = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(title)").group("title").order("title")
    @optionsissue = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(issue)").group("issue").order("issue")
    @optionscategory = Book.where(:publisher => "Acclaim Entertainment").select("DISTINCT(category)").group("category").order("category")
    respond_to do |format|
      format.html
      format.json { render json: @book }
      format.js
    end
  end

  private
    def set_book
      @book = Book.friendly.find(params[:id])
    end

    def set_title
      @title = Book.friendly.find(params[:title])
    end

    def authenticate
      authenticate_or_request_with_http_basic('Administration') do |username, password|
        sha512_of_password = Digest::SHA2.new(512).hexdigest(password)
        username == 'admin' && sha512_of_password == 'E4F7F152C58218FC912BB7B1CAC653794D2FCC37B70527B44DCAA96E3B68F20158975806FB61DADCB0A2595E374DA955B8EEADB9914B58E34BC27B635DE67FBA'
      end
    end

    def csvauthenticate
      case request.format
      when Mime::XML
        authenticate_or_request_with_http_basic('Administration') do |username, password|
          sha512_of_password = Digest::SHA2.new(512).hexdigest(password)
          username == 'admin' && sha512_of_password == 'DDDB04622B79FCED0EE0BD3381EFC468EC6CE1A110FE493135B179BAE8068416352B3D61077D1000F2A146B2F6B1AAF20D41D7B7A3CCD5E307625D086D5162FD'
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
      params.require(:book).permit(:issue, :title, :rdate, :note, :image, :image_remote_url, :writer, :writer2, :artist, :artist2, :colors, :letters, :editor, :eic, :cover, :isb, :link, :arc, :summary, :bookcode, :qr, :price, :price_in_dollars, :pricenm, :value_in_dollars, :price98, :printrun, :category, :status, :comicrating, :code, :event, :eventpart, :iskey, :keynote, :previews, :era, :country, :publisher, :printing, :tag_list, :slug)
    end
end
