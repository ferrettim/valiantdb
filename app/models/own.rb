class Own < ActiveRecord::Base
	include PublicActivity::Common
	include PublicActivity::Model
  	tracked except: :create, owner: :user, recipient: :book
	belongs_to :user, :counter_cache => true
	belongs_to :book
	after_create :award_user_points
	after_destroy :deduct_user_points

	private
	def award_user_points
		if book.category == "Paperback"
			user.add_points(TRADE_BONUS, "You added a paperback to your collection")
		elsif book.category == "Hardcover"
			user.add_points(HC_BONUS, "You added a hardcover to your collection")
		else
			user.add_points(OWN_BONUS, "You added a book to your collection")
		end
	end

	def deduct_user_points
		if book.category == "Paperback"
			user.deduct_points(TRADE_BONUS, "You removed a paperback to your collection")
		elsif book.category == "Hardcover"
			user.deduct_points(HC_BONUS, "You removed a hardcover to your collection")
		else
			user.deduct_points(OWN_BONUS, "You removed a book to your collection")
		end
	end
end
