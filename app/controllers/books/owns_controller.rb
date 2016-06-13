class Books::OwnsController < ApplicationController
	before_action :set_book
	skip_before_action :verify_authenticity_token
	respond_to :html, :json, :js

	def create
		@book.owns.where(user_id: current_user.id).first_or_create
		if user_signed_in? && current_user.wishes?(@book)
			@book.wishes.where(user_id: current_user.id).destroy_all
		end
		@own = Own.where(user_id: current_user.id, book_id: @book.id)
		Own.update(@own, :quantity => "1")
		respond_to do |format|
			format.html { redirect_to request.referer}
			format.js
		end
	end

	def update
	  @own = @book.owns.where(user_id: current_user.id)
	  Own.update(@own, own_params)
	  redirect_to request.referer
	  flash[:notice] = "Quantity has been updated"
	end

	def show
		redirect_to @book
	end

	def destroy
		@book.owns.where(user_id: current_user.id).destroy_all
		if user_signed_in? && current_user.sales?(@book)
			@book.sales.where(user_id: current_user.id).destroy_all
		end
		respond_to do |format|
			format.html { redirect_to @book}
			format.js
		end
	end

	private
		def set_book
			@book = Book.friendly.find(params[:book_id])
		end

		def own_params
			params.require(:own).permit(:quantity)
		end
end
