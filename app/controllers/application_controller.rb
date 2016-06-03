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
    config.x_frame_options = "ALLOWALL"
    config.x_content_type_options = "nosniff"
    config.x_xss_protection = "1; mode=block"
    config.x_download_options = "noopen"
    config.x_permitted_cross_domain_policies = "none"
    config.csp = {
      # "meta" values. these will shaped the header, but the values are not included in the header.
      report_only:  true,     # default: false
      preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.

      # directive values: these values will directly translate into source directives
      default_src: %w(http: https: 'self' 'unsafe-inline'),
      # frame_src: %w('self' *.twimg.com itunes.apple.com),
      # connect_src: %w(wws:),
      font_src: %w('self' https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/fonts/fontawesome-webfont.woff2?v=4.6.3 https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/fonts/glyphicons-halflings-regular.woff https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/fonts/glyphicons-halflings-regular.ttf https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/fonts/glyphicons-halflings-regular.woff2 https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/fonts/fontawesome-webfont.ttf?v=4.6.3 https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/fonts/fontawesome-webfont.woff?v=4.6.3 http://fonts.gstatic.com/s/montserrat/v7/zhcz-_WihjSQC0oHJ9TCYPk_vArhqVIZ0nv9q090hN8.woff2 http://fonts.gstatic.com/s/montserrat/v7/IQHow_FEYlDC4Gzy_m8fcoWiMMZ7xLd792ULpGE4W_Y.woff2 ),
      img_src: %w('self' http://rover.ebay.com http://adn.ebay.com http://img-cdn.mediaplex.com http://thumbs1.ebaystatic.com http://thumbs2.ebaystatic.com http://thumbs3.ebaystatic.com http://thumbs4.ebaystatic.com https://stats.g.doubleclick.net/r/collect?v=1&aip=1&t=dc&_r=3&tid=UA-52140019-2&cid=394449748.1464894513&jid=2139411111&_v=j44&z=1882774576 https://s3.amazonaws.com https://*.youtube.com https://www.google.com https://www.google-analytics.com https://cdnjs.cloudflare.com/ajax/libs/font-awesome data: ),
      media_src: %w('self' https://s3.amazonaws.com https://img.youtube.com ),
      object_src: %w('self'),
      script_src: %w('self' 'unsafe-inline' 'unsafe-eval' http://adn.ebay.com/cb?programId=1&campId=5337871987&toolId=10026&keyword=%28The%20Revisionist%2C1%29&width=575&height=90&font=1&textColor=000000&linkColor=0000AA&arrowColor=709aee&color1=709AEE&color2=[COLORTWO]&format=ImageLink&contentType=TEXT_AND_IMAGE&enableSearch=y&usePopularSearches=n&freeShipping=n&topRatedSeller=n&itemsWithPayPal=n&descriptionSearch=n&showKwCatLink=n&excludeCatId=&excludeKeyword=&catId=900&disWithin=200&ctx=n&autoscroll=n&title=this&cachebuster=842494 http://adn.ebay.com/files/js/min/ebay_activeContent-min.js https://cdnjs.cloudflare.com/ajax/libs/nprogress/0.2.0/nprogress.min.js https://www.google-analytics.com/analytics.js https://www.google.com/uds/?file=visualization&v=1&packages=corechart&async=2 https://cdnjs.cloudflare.com/ajax/libs/jasny-bootstrap/3.1.3/js/jasny-bootstrap.min.js https://cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.3/modernizr.min.js https://www.google.com/jsapi https://cdnjs.cloudflare.com/ajax/libs/chartkick/2.0.0/chartkick.min.js https://cdnjs.cloudflare.com/ajax/libs/jquery-ujs/1.2.1/rails.min.js https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js http://code.jquery.com/jquery-2.2.4.min.js http://code.jquery.com/ui/1.11.4/jquery-ui.min.js https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js http://js-agent.newrelic.com/nr-943.min.js http://bam.nr-data.net/1/fd1a36e0d1?a=4605085&v=943.9bd99bf&to=cV9ZEkMLWFlVRx8EXl1bRElTC1tYUVlc&rst=12784&ref=http://www.comicark.com/books/boom/all&qt=1909&ap=8426&be=10574&fe=2190&dc=241&perf=%7B%22timing%22:%7B%22of%22:1464879803707,%22n%22:0,%22u%22:10392,%22ue%22:10392,%22dl%22:10404,%22di%22:10815,%22ds%22:10815,%22de%22:10896,%22dc%22:12764,%22l%22:12764,%22le%22:12766,%22f%22:0,%22dn%22:0,%22dne%22:0,%22c%22:0,%22ce%22:0,%22rq%22:7,%22rp%22:10388,%22rpe%22:10393%7D,%22navigation%22:%7B%7D%7D&jsonp=NREUM.setToken https://js-agent.newrelic.com https://www.google-analytics.com/ga.js http://www.google-analytics.com/ga.js https://www.google.com https://www.google-analytics.com),
      style_src: %w('self' 'unsafe-inline' 'unsave-eval' https://cdnjs.cloudflare.com/ajax/libs/nprogress/0.2.0/nprogress.min.css https://ajax.googleapis.com/ajax/static/modules/gviz/1.0/core/tooltip.css https://www.google.com/uds/api/visualization/1.0/cc4e780f27c723c0cb35ec1e38ec2bb9/ui+en.css https://cdnjs.cloudflare.com/ajax/libs/normalize/4.1.1/normalize.min.css https://cdnjs.cloudflare.com/ajax/libs/jasny-bootstrap/3.1.3/css/jasny-bootstrap.min.css https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css  https://fonts.googleapis.com http://fonts.googleapis.com https://fonts.googleapis.com/css?family=Raleway:400,700 https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/css/bootstrap.min.css https://fonts.googleapis.com/css?family=Roboto:400,700 http://fonts.googleapis.com/css?family=Roboto:400,700),
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
