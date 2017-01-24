class PollvoteOption < ApplicationRecord
  belongs_to :poll
  validates :title, presence: true
  has_many :pollvotes, dependent: :destroy
  has_many :users, through: :pollvotes
end
