class Book < ActiveRecord::Base
	include PublicActivity::Model
	tracked only: [:create]
	acts_as_votable
	ratyrate_rateable 'book'
	validates :issue, presence: true
	validates :title, presence: true
	validates :rdate, presence: true
	has_attached_file :image, :styles => { :medium => "300x300>", 
										   :thumb => "150x150>",
										   :mini => "36x36>" }, 
							  :convert_options => { 
                                           :medium => "-quality 75 -strip",
                                           :thumb => "-quality 75 -strip",
                                           :mini => "-quality 75 -strip" },
							  :default_url => "https://s3.amazonaws.com/valiantdb/books/images/medium/missing.png"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	
	searchkick suggest: ["title", "writer", "writer2" "artist", "colors", "cover", "letters", "editors", "eic"], 
			   unsearchable: ["id", "created_at", "updated_at", "notes", "summary"],
			   autocomplete: ["title"],
			   text_start: ["title"]
	has_many :wishes, :dependent => :destroy
	has_many :owns, :dependent => :destroy
	has_many :sales, :dependent => :destroy
	has_many :previews, :dependent => :destroy
	has_many :taggings
	has_many :tags, through: :taggings
	has_many :comments, :dependent => :destroy
	has_paper_trail

	def to_param
		"#{id}-#{title.to_s.parameterize}-#{issue.to_i}-#{cover.to_s.parameterize}"
	end

	def price_in_dollars
		price.to_d/100 if price
	end

	def price_in_dollars=(dollars)
		self.price = dollars.to_d*100 if dollars.present?
	end

	def value_in_dollars
		pricenm.to_d/100 if pricenm
	end

	def value_in_dollars=(dollars)
		self.pricenm = dollars.to_d*100 if dollars.present?
	end

	def negative
	    self != 0 && (self != (self * self) / self.abs)
	end

	def self.tagged_with(name)
		Tag.find_by_name!(name).books
	end

	def self.tag_counts
		Tag.select("tags.*, count(taggings.tag_id) as count").
			joins(:taggings).group("taggings.tag_id")
	end

	def tag_list
		tags.map(&:name).join(", ")
	end

	def tag_list=(names)
		self.tags = names.split(", ").map do |t|
			Tag.where(name: t.strip).first_or_create!
		end
	end

	def self.to_csv
    attributes = %w{title issue writer artist cover rdate category printrun note} 
	    CSV.generate(headers: true) do |csv|
	      csv << attributes
	      all.each do |book|
	        csv << book.attributes.values_at(*attributes)
	      end
	    end
  	end

  	def self.import(file)
	    CSV.foreach(file.path, headers: true) do |row|

	      product_hash = row.to_hash # exclude the price field
	      product = Book.where(id: product_hash["id"])

	      if product.count == 1
	        product.first.update_attributes(product_hash)
	      else
	        Book.create!(product_hash)
	      end # end if !product.nil?
	    end # end CSV.foreach
	  end # end self.import(file)

  	def self.super_csv
    attributes = %w{id title issue cover category pricenm publisher note}
	    CSV.generate(headers: true) do |csv|
	      csv << attributes
	      all.each do |book|
	        csv << book.attributes.values_at(*attributes)
	      end
	    end
  	end

  	def self.ext_csv
    attributes = %w{title issue cover category publisher}
	    CSV.generate(headers: true) do |csv|
	      csv << attributes
	      all.each do |book|
	        row = book.attributes.values_at(*attributes)
	        row << "http://www.valiantdatabase.com/books/" + Book.find(book.id).to_param
	        csv << row
	      end
	    end
  	end

  	def self.assign_from_row(row)
  		book = Book.where(id: row[:id]).first_or_initialize
		book.assign_attributes row.to_hash.slice(:title, :issue, :writer, :artist, :colors, :cover, :rdate, :category, :note, :bookcode)
		book
	end

	 def previous_book
	   Book.where(:title => title).where(:category => "Default").where(:era => era).where('issue < ?', issue).order(issue: :desc).first
	 end

	 def next_book
	   Book.where(:title => title).where(:category => "Default").where(:era => era).where('issue > ?', issue).order(issue: :asc).first
	 end

	 def previous_tpb
	   Book.where(:title => title).where(:category => "Paperback").where(:era => era).where('issue < ?', issue).order(issue: :desc).first
	 end

	 def next_tpb
	   Book.where(:title => title).where(:category => "Paperback").where(:era => era).where('issue > ?', issue).order(issue: :asc).first
	 end

	 def previous_hc
	   Book.where(:title => title).where(:category => "Hardcover").where(:era => era).where('issue < ?', issue).order(issue: :desc).first
	 end

	 def next_hc
	   Book.where(:title => title).where(:category => "Hardcover").where(:era => era).where('issue > ?', issue).order(issue: :asc).first
	 end

end
