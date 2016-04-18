class Own < ActiveRecord::Base
	include PublicActivity::Common
	include PublicActivity::Model
  	tracked except: :create, owner: :user, recipient: :book
	belongs_to :user
	belongs_to :book
end
