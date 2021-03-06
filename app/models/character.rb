class Character < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :name, use: :slugged
	validates :name, presence: true
	has_attached_file :image, :styles => { :medium => "300x300>", 
										   :thumb => "150x150>" }, 
							  :convert_options => { 
                                           :medium => "-quality 75 -strip",
                                           :thumb => "-quality 75 -strip" },
							  :default_url => "https://s3.amazonaws.com/valiantdb/books/images/medium/missing.png"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	
end
