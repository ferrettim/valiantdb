class CollectiblesController < ApplicationController
  before_action :set_collectible, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json, :js

  def new
    @collectible = Collectible.new
    respond_with(@collectible)
  end

  def edit
  end

  def create
    @collectible = Collectible.new(collectible_params)
    @collectible.save
    respond_with(@collectible)
  end

  def update
    @collectible = Collectible.find(params[:id])
    if @collectible.update_attributes!(collectible_params)
      respond_to do |format|
        format.html { redirect_to( @collectible )}
        format.json { render :json => @collectible }
      end
    else
      respond_to do |format|
        format.html { render :action  => :edit } # edit.html.erb
        format.json { render :nothing =>  true }
      end
    end
  end

  def destroy
    @collectible.destroy
    respond_with(@collectible)
  end

  def show
    @collectible = Collectible.find(params[:id])
    @ownusers = User.joins(:itemowns).where("itemowns.collectible_id = ?", @collectible.id).includes(:itemowns).order("itemowns.quantity asc")
    respond_to do |format|
      format.html
      format.json { render :json => @collectible }
    end
  end

  def all
    @pgtitle = "All Collectibles"
    @tcount = Collectible.all.count
    @collectible = Collectible.all.order(title: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @collectible }
      format.js
    end
  end

  private
	  def set_collectible
	     @collectible = Collectible.find(params[:id])
	  end

	  def collectible_params
	    params.require(:collectible).permit(:title, :rdate, :description, :manufacturer, :link, :image, :slug, :price, :price_in_dollars, :printrun, :category)
	  end

end
