class Collectibles::ItemwishesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_collectible

	def create
		if Rails.env.production?
			(@collectible.itemwishes.where(user_id: current_user.id).first_or_create).create_activity :create, owner: current_user, recipient: :collectible
		else
			(@collectible.itemwishes.where(user_id: current_user.id).first_or_create).create_activity :create, owner: current_user, recipient: :collectible
		end
		unless @collectible.rdate.future?
			User.where.not(id: current_user.id).each do |u|
				u.forsale_collectibles.where(:id => @collectible.id).each do
					current_user.send_message(
					u,
					"The user below has added " + @collectible.title.to_s + " to their wishlist and you have one for sale. By replying, you will be put into contact with the potential buyer. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
					"Looking for " + @collectible.title.to_s )
				end
			end
		end
		respond_to do |format|
			format.html { redirect_to @collectible }
			format.js
		end
	end

	def destroy
		@collectible.itemwishes.where(user_id: current_user.id).destroy_all
		respond_to do |format|
			format.html { redirect_to @collectible}
			format.js
		end
	end

	private
		def set_collectible
			@collectible = Collectible.find(params[:collectible_id])
		end

end
