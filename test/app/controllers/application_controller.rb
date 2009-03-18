# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # Initialize GetText and Content-Type.
  # You need to call this once a request from WWW browser.
  # You can select the scope of the textdomain.
  # 1. If you call init_gettext in ApplicationControler,
  #    The textdomain apply whole your application.
  # 2. If you call init_gettext in each controllers
  #    (In this sample, blog_controller.rb is applicable)
  #    The textdomains are applied to each controllers/views.
  init_gettext "rails_test"  # textdomain, options(:charset, :content_type)
end
