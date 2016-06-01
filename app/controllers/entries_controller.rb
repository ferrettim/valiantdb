class EntriesController < ApplicationController
  before_action :set_feed, only: :index

  def index
    @entries = @feed.entries.order('published desc')
  end

  def show
    @entry = @set_entry
  end

  private
  def set_feed
    @feed = Feed.find(params[:id])
  end

  def set_entry
    @set_entry = Entry.find(params[:id])
end