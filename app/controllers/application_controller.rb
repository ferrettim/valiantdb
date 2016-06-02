require 'excon'

class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  
  helper_method :mailbox, :conversation
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery except: :sign_in, with: :exception
  # before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  after_filter :user_activity
  after_filter :store_location
  hide_action :current_user

  SecureHeaders::Configuration.default do |config|
    config.secure_cookies = false # mark all cookies as "secure"
    config.hsts = "max-age=#{20.years.to_i}; includeSubdomains; preload"
    config.x_frame_options = "DENY"
    config.x_content_type_options = "nosniff"
    config.x_xss_protection = "1; mode=block"
    config.x_download_options = "noopen"
    config.x_permitted_cross_domain_policies = "none"
    config.csp = {
      # "meta" values. these will shaped the header, but the values are not included in the header.
      report_only:  true,     # default: false
      preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.

      # directive values: these values will directly translate into source directives
      default_src: %w(https: 'self'),
      # frame_src: %w('self' *.twimg.com itunes.apple.com),
      # connect_src: %w(wws:),
      font_src: %w('self' http://fonts.gstatic.com/s/montserrat/v7/zhcz-_WihjSQC0oHJ9TCYPk_vArhqVIZ0nv9q090hN8.woff2 http://fonts.gstatic.com/s/montserrat/v7/IQHow_FEYlDC4Gzy_m8fcoWiMMZ7xLd792ULpGE4W_Y.woff2 ),
      img_src: %w('self' https://s3.amazonaws.com https://*.youtube.com https://www.google.com https://www.google-analytics.com https://cdnjs.cloudflare.com/ajax/libs/font-awesome data: ),
      media_src: %w('self' https://s3.amazonaws.com https://img.youtube.com ),
      object_src: %w('self'),
      script_src: %w('self' 'unsafe-inline' https://js-agent.newrelic.com https://www.google-analytics.com/ga.js http://www.google-analytics.com/ga.js https://www.google.com https://www.google-analytics.com),
      style_src: %w('self' 'unsafe-inline' https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.2.0/css/font-awesome.min.css https://fonts.googleapis.com https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/css/bootstrap.min.css http://fonts.googleapis.com https://fonts.googleapis.com/css?family=Raleway:400,700 https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/css/bootstrap.min.css https://fonts.googleapis.com/css?family=Roboto:400,700 http://fonts.googleapis.com/css?family=Roboto:400,700),
      base_uri: %w('self'),
      child_src: %w('self'),
      # form_action: %w('self' ),
      frame_ancestors: %w('none'),
      plugin_types: %w(application/x-shockwave-flash),
      # block_all_mixed_content: true, # see [http://www.w3.org/TR/mixed-content/](http://www.w3.org/TR/mixed-content/)
      # upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
      report_uri: %w(https://report-uri.io/example-csp)
    }

  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :avatar) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :avatar) }
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
    if (request.path != "http://comicark.com/login" &&
        request.path != "http://comicark.com/register" &&
        request.path != "http://comicark.com/logout" &&
        request.path != "http://www.comicark.com/login" &&
        request.path != "http://www.comicark.com/register" &&
        request.path != "http://www.comicark.com/logout" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    root_path
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
