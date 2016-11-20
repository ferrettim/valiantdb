require 'excon'

class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  helper_method :mailbox, :conversation
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery except: :sign_in, with: :exception
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  after_action :user_activity
  after_action :store_location

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :avatar])
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  # def after_sign_in_path_for(resource)
    # root_url + "users/" + current_user.id.to_s + "/profile"
    # request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  # end

  def store_location
  # store last url - this is needed for post-login redirect to whatever the user last visited.
  return unless request.get?
    if (request.path != "http://valiantdatabase.com/login" &&
        request.path != "http://valiantdatabase.com/register" &&
        request.path != "http://valiantdatabase.com/logout" &&
        request.path != "http://www.valiantdatabase.com/login" &&
        request.path != "http://www.valiantdatabase.com/register" &&
        request.path != "http://www.valiantdatabase.com/logout" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def user_for_paper_trail
    nil # disable whodunnit tracking
  end

  def default_headers
    headers["X-Frame-Options"] = "ALLOW-FROM http://www.nerdylegion.com"
  end

  private

  def user_activity
  	current_user.try :touch
  end

  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end
end
