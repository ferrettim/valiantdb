SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: true, # mark all cookies as "Secure"
    httponly: true, # mark all cookies as "HttpOnly"
    samesite: {
      strict: true # mark all cookies as SameSite=Strict
    }
  }
  config.hsts = "max-age=#{20.years.to_i}; includeSubdomains; preload"
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = "origin-when-cross-origin"
  config.csp = {
    # "meta" values. these will shaped the header, but the values are not included in the header.
    report_only: true,      # default: false
    preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.

    # directive values: these values will directly translate into source directives
    default_src: %w(http: 'self' 'unsafe-inline'),
    frame_src: %w('self'),
    connect_src: %w(ws: wws: http: https:),
    font_src: %w('self' fonts.gstatic.com fonts.googleapis.com data:),
    img_src: %w('self' s3.amazonaws.com amazonaws.com data:),
    media_src: %w('self'),
    object_src: %w('self'),
    script_src: %w('self' 'unsafe-eval' www.google-analytics.com fonts.googleapis.com),
    style_src: %w('self' 'unsafe-inline' www.google-analytics.com fonts.googleapis.com),
    base_uri: %w('self'),
    child_src: %w('self'),
    form_action: %w('self' facebook.com google.com),
    frame_ancestors: %w('none'),
    plugin_types: %w(application/x-shockwave-flash),
    block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
    upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
    report_uri: %w('/csp_reports')
  }
  config.hpkp = {
    report_only: false,
    max_age: 60.days.to_i,
    include_subdomains: true,
    report_uri: "https://report-uri.io/example-hpkp",
    pins: [
      {sha256: "abc"},
      {sha256: "123"}
    ]
  }
end