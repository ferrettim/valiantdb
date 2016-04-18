class CharactersController < ApplicationController
  before_action :set_character, only: [:show, :edit, :update, :destroy]
  autocomplete :character, :creator
  autocomplete :character, :creator2
  respond_to :html, :json, :js

  def new
    @character = Character.new
    respond_with(@character)
  end

  def edit
  end

  def create
    @character = Character.new(character_params)
    @character.save
    respond_with(@character)
  end

  def update
    @character = Character.friendly.find(params[:id])
    if @character.update_attributes!(character_params)
      respond_to do |format|
        format.html { redirect_to( @character )}
        format.json { render :json => @character }
      end
    else
      respond_to do |format|
        format.html { render :action  => :edit } # edit.html.erb
        format.json { render :nothing =>  true }
      end
    end
  end

  def destroy
    @character.destroy
    respond_with(@character)
  end

  def show
    @character = Character.friendly.find(params[:id])
    if @character.appera == "Current"
		@era = "2012-05-01"
		@era2 = Date.today
	elsif @character.appera == "Classic"
		@era = "1991-05-01"
		@era2 = "1996-09-30"
	else
		@era = "1996-10-01"
		@era2 = "2007-12-31"
	end
    respond_to do |format|
      format.html
      format.json { render :json => @character }
    end
  end

  def all
    @pgtitle = "All Characters"
    @tcount = Character.all.count
    @character = Character.all.order(name: :asc).page(params[:page]).per(24)
    respond_to do |format|
      format.html
      format.json { render json: @character }
      format.js
    end
  end

  private
	  def set_character
	     @character = Character.friendly.find(params[:id])
	  end

	  def character_params
	    params.require(:character).permit(:name, :image, :creator, :creator2, :apptitle, :appissue, :appera, :origin, :power, :power2, :power3, :power4, :power5, :slug)
	  end

end
