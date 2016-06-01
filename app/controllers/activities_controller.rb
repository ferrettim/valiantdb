class ActivitiesController < ApplicationController
  before_filter :set_locale

  def index
  	@activities = PublicActivity::Activity.order("created_at desc")
  end

  private
  	def set_locale
  		I18n.locale = params[:locale] if params[:locale].present?
  	end

end
