require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get custom_error_message" do
    get :custom_error_message, :lang => "ja"
    assert_html("ja/custom_error_message.html")
    assert_response :success

    get :custom_error_message, :lang => "en"
    assert_html("en/custom_error_message.html")

    # not match
    get :custom_error_message, :lang => "kr"
    assert_html("en/custom_error_message.html")

    # custom_error_message_fr.html.erb
    get :custom_error_message, :lang => "fr"
    assert_html("fr/custom_error_message.html")
  end

  test "should get custom plural error_messages" do
    get :custom_error_message, :lang => "ja", :plural => "true"
    assert_html("ja/custom_error_message_with_plural.html")
    assert_response :success

    get :custom_error_message, :lang => "en", :plural => "true"
    assert_html("en/custom_error_message_with_plural.html")

    get :custom_error_message, :lang => "fr", :plural => "true"
    assert_html("fr/custom_error_message_with_plural.html")
  end

  test "should get localized distance_of_time_in_words" do
    get :distance_of_time_in_words, :lang => "ja"
    assert_html("ja/distance_of_time_in_words.html")
    assert_response :success

    get :distance_of_time_in_words, :lang => "en"
    assert_html("en/distance_of_time_in_words.html")
    assert_response :success

    get :distance_of_time_in_words, :lang => "fr"
    assert_html("fr/distance_of_time_in_words.html")
    assert_response :success
  end

end
