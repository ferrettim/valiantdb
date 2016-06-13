class Sale < ActiveRecord::Base
	include PublicActivity::Common
	include PublicActivity::Model
  	tracked except: :create, owner: :user, recipient: :book
	belongs_to :user, :counter_cache => true
	belongs_to :book
	after_create :award_user_points
	after_destroy :deduct_user_points

	private
	def award_user_points
		user.add_points(SELL_BONUS, "You are selling a book!")
	end

	def deduct_user_points
		user.deduct_points(SELL_BONUS, "You are selling a book!")
	end
end
