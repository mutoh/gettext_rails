require 'test_helper'

class MailersControllerTest < ActionController::TestCase
  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  test "should get singlepart message" do
    # Japanese
    get :singlepart, :lang => "ja"
    data = ActionMailer::Base.deliveries[0].decoded
    assert_mail("ja/singlepart.html", data)
   
    # English
    get :singlepart, :lang => "en"
    data = ActionMailer::Base.deliveries[1].decoded
    assert_mail("en/singlepart.html", data)

    # not match -> English
    get :singlepart, :lang => "kr"
    data = ActionMailer::Base.deliveries[2].decoded
    assert_mail("en/singlepart.html", data)

    # singlepart_fr.rhtml
    get :singlepart, :lang => "fr"
    data = ActionMailer::Base.deliveries[3].decoded
    assert_mail("fr/singlepart.html", data)
  end

  test "should get multipart message" do
    # Japanese
    get :multipart, :lang => "ja"
    data = ActionMailer::Base.deliveries[0].decoded
    assert_multipart("ja/multipart.html", data)

    # English
    get :multipart, :lang => "en"
    data = ActionMailer::Base.deliveries[1].decoded
    assert_multipart("en/multipart.html", data)

    # not match -> English
    get :multipart, :lang => "kr"
    data = ActionMailer::Base.deliveries[2].decoded
    assert_multipart("en/multipart.html", data)

    # multipart_fr.rhtml
    get :multipart, :lang => "fr"
    data = ActionMailer::Base.deliveries[3].decoded
    assert_multipart("fr/multipart.html", data)
  end

end
