class Pollvote < ApplicationRecord
  belongs_to :user
  belongs_to :pollvote_option
  after_create :award_user_points
	after_destroy :deduct_user_points

  private
  def award_user_points
    user.add_points(POLL_BONUS, "You participated in the latest poll")
  end

  def deduct_user_points
    user.deduct_points(POLL_BONUS, "You did not participate in the latest poll")
  end
end
