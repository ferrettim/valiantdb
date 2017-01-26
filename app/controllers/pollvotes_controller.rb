class PollvotesController < ApplicationController
  def create
    if current_user && params[:poll] && params[:poll][:id] && params[:pollvote_option] && params[:pollvote_option][:id]
      @poll = Poll.find_by_id(params[:poll][:id])
      @option = @poll.pollvote_options.find_by_id(params[:pollvote_option][:id])
      if @option && @poll && !current_user.pollvoted_for?(@poll)
        @option.pollvotes.create({user_id: current_user.id})
      else
        render js: 'alert(\'Your vote cannot be saved. Have you already voted?\');'
      end
    else
      render js: 'alert(\'Your vote cannot be saved.\');'
    end
    respond_to do |format|
      format.js
    end
  end
end
