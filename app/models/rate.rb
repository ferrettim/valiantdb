class Rate < ActiveRecord::Base
  include PublicActivity::Common
  include PublicActivity::Model
  tracked except: :create, owner: :rater, recipient: :rateable
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true

  #attr_accessible :rate, :dimension

end