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
  init_gettext "blog"  # textdomain, options(:charset, :content_type)

  I18n.supported_locales = Dir[ File.join(RAILS_ROOT, 'locale/*') ].collect{|v| File.basename(v)}

  # You can set callback methods. These methods are called on the each WWW request.
=begin
  def sample_before_init_gettext
    p "before_init_gettext"
    set_locale "zh"  # Set locale forcely.
  end
  before_init_gettext :sample_before_init_gettext
  def sample_after_init_gettext
    p "after_init_gettext"
  end
  after_init_gettext :sample_after_init_gettext
=end
=begin
   # you can redefined the title/explanation of the top of the error message.
  ActionView::Helpers::ActiveRecordHelper::L10n.set_error_message_title(N_("An error is occured on %{record}"), N_("%{num} errors are occured on %{record}"))
  ActionView::Helpers::ActiveRecordHelper::L10n.set_error_message_explanation(N_("The error is:"), N_("The errors are:"))
=end

end
