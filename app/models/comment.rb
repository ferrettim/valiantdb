class Comment < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :book

  after_create :award_user_points
  after_destroy :deduct_user_points

  private
	def award_user_points
		user.add_points(NOTE_BONUS, "You added a new note!")
	end

	def deduct_user_points
		user.deduct_points(NOTE_BONUS, "You removed a note!")
	end
end
