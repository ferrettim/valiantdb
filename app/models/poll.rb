class Poll < ApplicationRecord
  has_many :pollvote_options, dependent: :destroy
  validates :topic, presence: true
  accepts_nested_attributes_for :pollvote_options, :reject_if => :all_blank, :allow_destroy => true

  def normalized_votes_for(option)
    '%.2f' % (votes_summary == 0 ? 0 : (option.pollvotes.count.to_f / votes_summary) * 100)
  end

  def votes_summary
    pollvote_options.inject(0) {|summary, option| summary + option.pollvotes.count}
  end

end
