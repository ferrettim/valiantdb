class Books::SalesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_book

	def create
		if Rails.env.production?
			(@book.sales.where(user_id: current_user.id).first_or_create).create_activity :create, owner: current_user, recipient: :book
		else
			(@book.sales.where(user_id: current_user.id).first_or_create).create_activity :create, owner: current_user, recipient: :book
		end
		if @book.category == "Default"
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
				    current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (A cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " A cover)")
				end
			end
		elsif @book.note.include?("B")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (B cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " B cover)")
				end
			end
		elsif @book.note.include?("C")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (C cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " C cover)")
				end
			end
		elsif @book.note.include?("1:10 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:10 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:10 cover)")
				end
			end
		elsif @book.note.include?("1:20 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:20 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:20 cover)")
				end
			end
		elsif @book.note.include?("1:25 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:25 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:25 cover)")
				end
			end
		elsif @book.note.include?("1:40 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:40 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:40 cover)")
				end
			end
		elsif @book.note.include?("1:50 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:50 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:50 cover)")
				end
			end
		elsif @book.note.include?("1:60 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:60 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:60 cover)")
				end
			end
		elsif @book.note.include?("1:75 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:75 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:75 cover)")
				end
			end
		elsif @book.note.include?("1:80 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:80 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:80 cover)")
				end
			end
		elsif @book.note.include?("1:100 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:100 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:100 cover)")
				end
			end
		elsif @book.note.include?("1:125 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:125 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:125 cover)")
				end
			end
		elsif @book.note.include?("1:150 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:150 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:150 cover)")
				end
			end
		elsif @book.note.include?("1:200 ")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (1:200 cover by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " 1:200 cover)")
				end
			end
		elsif @book.note.include?("exclusive")
			User.where.not(id: current_user.id).each do |u|
				u.wished_books.where(:id => @book.id).each do
			    	current_user.send_message(
						u,
						"The user below has posted " + @book.title.to_s + " #" + @book.issue.to_s + " (exclusive variant by " + @book.cover.to_s + ") for sale which is on your wishlist. By replying, you will be put into contact with the seller to further inquire about this item. All sales are the responsibility of the buyer/seller and not of Valiant Database or anyone involved with the development of the site.",
						"FS " + @book.title.to_s + " #" + @book.issue.to_s + " (" + @book.cover.to_s + " exclusive variant cover)")
				end
			end
		end
		respond_to do |format|
			format.html { redirect_to @book}
			format.js
		end
	end

	def destroy
		@book.sales.where(user_id: current_user.id).destroy_all
		respond_to do |format|
			format.html { redirect_to @book}
			format.js
		end
	end

	private
		def set_book
			@book = Book.find(params[:book_id])
		end
end
