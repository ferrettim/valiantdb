# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( *.js *.js.erb *.js.coffee *.css *.css.scss /^[-_a-zA-Z0-9]*\..*/ bx_loader.gif controls.png fonts/flexslider-icon.eot fonts/flexslider-icon.woff fonts/flexslider-icon.ttf *.png *.gif )