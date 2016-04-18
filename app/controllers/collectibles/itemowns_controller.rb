class Collectibles::ItemownsController < ApplicationController
	before_action :set_collectible
	skip_before_action :verify_authenticity_token
	respond_to :html, :json, :js

	def create
		(@collectible.itemowns.where(user_id: current_user.id).first_or_create)
		if user_signed_in? && current_user.itemwishes?(@collectible)
			@collectible.itemwishes.where(user_id: current_user.id).destroy_all
		end
		@itemown = Itemown.where(user_id: current_user.id, collectible_id: @collectible.id)
		respond_to do |format|
			format.html { redirect_to request.referer}
			format.js
		end
	end

	def update
	  @itemown = @collectible.itemowns.where(user_id: current_user.id)
	  Itemown.update(@itemown, itemown_params)
	  redirect_to request.referer
	  flash[:notice] = "Update successful!"
	end

	def show
		redirect_to @collectible
	end

	def destroy
		@collectible.itemowns.where(user_id: current_user.id).destroy_all
		respond_to do |format|
			format.html { redirect_to @collectible}
			format.js
		end
	end

	private
		def set_collectible
			@collectible = Collectible.find(params[:collectible_id])
		end

		def itemown_params
			params.require(:itemown).permit(:quantity)
		end
end
