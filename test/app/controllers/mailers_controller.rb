class MailersController < ApplicationController
#  layout "mailers"

  init_gettext "rails_test"
  
  def index
  end

  def singlepart
    Mailer.deliver_singlepart
    render :text => Mailer.create_singlepart.encoded, :layout => true
  end

  def multipart
    Mailer.deliver_multipart
    render :text => Mailer.create_multipart.encoded, :layout => true
  end
end
