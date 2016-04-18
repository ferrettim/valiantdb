class Collectibles::ItemsalesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_collectible

	def create
		if Rails.env.production?
			(@collectible.itemsales.where(user_id: current_user.id).first_or_create).create_activity :create, owner: current_user, recipient: :collectible
		else
			(@collectible.itemsales.where(user_id: current_user.id).first_or_create).create_activity :create, owner: current_user, recipient: :collectible
		end
		User.where.not(id: current_user.id).each do |u|
			u.wished_collectibles.where(:id => @collectible.id).each do
				current_user.send_message(
				u,
				"The user below has posted " + @collectible.title.to_s + " for sale and this item is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
				"FS " + @collectible.title.to_s )
			end
		end
		respond_to do |format|
			format.html { redirect_to @collectible}
			format.js
		end
	end

	def destroy
		@collectible.itemsales.where(user_id: current_user.id).destroy_all
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
