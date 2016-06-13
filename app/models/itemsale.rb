class Itemsale < ActiveRecord::Base
	include PublicActivity::Common
	include PublicActivity::Model
  	tracked except: :create, owner: :user, recipient: :collectible
	belongs_to :user
	belongs_to :collectible
end
