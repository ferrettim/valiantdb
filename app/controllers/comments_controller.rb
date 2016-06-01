class CommentsController < ApplicationController
	before_action :set_book

	def create
	    @comment = @book.comments.build(comment_params)
	    @comment.user_id = current_user.id

	    if @comment.save
	      respond_to do |format|
	        format.html { redirect_to :back }
	        format.js
	      end
	    else
	      flash[:alert] = "Check the comment form, something went wrong."
	      render root_path
	    end
	end

	def destroy
	    @comment = @book.comments.find(params[:id])

	    if @comment.user_id == current_user.id
	      @comment.delete
	      respond_to do |format|
	        format.html { redirect_to :back }
	        format.js
	      end
	    end
	  end

	private

	def comment_params  
	  params.require(:comment).permit(:content)
	end

	def set_book 
	  @book = Book.friendly.find(params[:book_id])
	end  
end
