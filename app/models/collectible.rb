class Collectible < ActiveRecord::Base
	validates :title, presence: true
	has_attached_file :image, :styles => { :medium => "300x300>", 
										   :thumb => "150x150>", 
										   :mini => "36x36>" }, 
							  :convert_options => { 
                                           :medium => "-quality 75 -strip",
                                           :thumb => "-quality 75 -strip", 
                                           :mini => "-quality 75 -strip" },
							  :default_url => "https://s3.amazonaws.com/valiantdb/books/images/medium/missing.png"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	has_many :itemwishes, :dependent => :destroy
	has_many :itemowns, :dependent => :destroy
	has_many :itemsales, :dependent => :destroy

	def to_param
		"#{id}-#{title.to_s.parameterize}-#{rdate.strftime("%Y")}"
	end

	def price_in_dollars
		price.to_d/100 if price
	end

	def price_in_dollars=(dollars)
		self.price = dollars.to_d*100 if dollars.present?
	end
	
end