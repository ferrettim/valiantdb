class Level < ActiveRecord::Base
	has_many :users

	def self.find_level_for_score(score)
		Level.where("required_score <= ?", score).order("required_score DESC").first
	end
end
