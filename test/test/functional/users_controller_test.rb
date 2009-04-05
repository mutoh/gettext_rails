require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get error_message" do
    get :error_message, :lang => "ja"
    assert_html("ja/error_message.html")
    assert_response :success

    get :error_message, :lang => "en"
    assert_html("en/error_message.html")

    # not match
    get :error_message, :lang => "kr"
    assert_html("en/error_message.html")

    # error_message_fr.html.erb
    get :error_message, :lang => "fr"
    assert_html("fr/error_message.html")
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
