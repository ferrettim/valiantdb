class BooksubsController < ApplicationController

  def create
		@booksub = Booksub.new
    @booksub.user_id = current_user.id
    @booksub.book_title = params[:title]
    @booksub.save
		redirect_to request.referer
	end

	def update
	  current_user.booksubs.where(user_id: current_user.id)
	  redirect_to request.referer
	  flash[:notice] = "Update successful!"
	end

  def new
    Booksub.new
  end

	def show
		redirect_to root_path
	end

	def destroy
		current_user.booksubs.where(user_id: current_user.id).destroy_all
		respond_to do |format|
			format.html { redirect_to root_path }
			format.js
		end
	end

  private
  def booksubs_params
    params.require(:booksubs).permit(:user_id, :book_title)
  end
end
