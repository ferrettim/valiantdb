class PollsController < ApplicationController
  def index
    if user_signed_in? && current_user.super_admin?
      @polls = Poll.all.order(created_at: :desc)
    else
      redirect_to root_url
    end
  end

  def show
    @poll = Poll.includes(:pollvote_options).find_by_id(params[:id])
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(poll_params)
    if @poll.save
      flash[:success] = 'Poll was created!'
      redirect_to polls_path
    else
      render 'new'
    end
  end

  def edit
  @poll = Poll.find_by_id(params[:id])
end

def update
  @poll = Poll.find_by_id(params[:id])
  if @poll.update_attributes(poll_params)
    flash[:success] = 'Poll was updated!'
    redirect_to polls_path
  else
    render 'edit'
  end
end

def destroy
  @poll = Poll.find_by_id(params[:id])
  if @poll.destroy
    flash[:success] = 'Poll was destroyed!'
  else
    flash[:warning] = 'Error destroying poll...'
  end
  redirect_to polls_path
end

  private

  def poll_params
    params.require(:poll).permit(:topic, :image1, :image2, :image3, pollvote_options_attributes: [:id, :title, :_destroy])
  end
end
