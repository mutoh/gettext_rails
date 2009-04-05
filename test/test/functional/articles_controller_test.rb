require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  test "should get index" do
    get :list, :lang => "ja"
    assert_html("ja/list.html")
    assert_response :success

    get :list, :lang => "en"
    assert_html("en/list.html")

    # not match
    get :list, :lang => "kr"
    assert_html("en/list.html")
  
    # list_fr.rhtml
    get :list, :lang => "fr"
    assert_html("fr/list.html")
  end

  test "should get new" do
    get :new, :lang => "ja"
    assert_html("ja/new.html")
    assert_response :success
    assert_not_nil assigns(:article)

    get :new, :lang => "en"
    assert_html("en/new.html")
    assert_response :success
    assert_not_nil assigns(:article)

    get :new, :lang => "fr"  # Localized View.
    assert_html("fr/new.html")
    assert_response :success
    assert_not_nil assigns(:article)
  end

  test "should create article" do
    assert_difference('Article.count') do
      post :create, :article => {:title => "aaaaaaaaaaa", :description => "BBBBBBBBBBB" }
    end

    assert_redirected_to article_path(assigns(:article))
  end
  test "should be errors" do
    post :create, :article => {:title => "", :description => "", :lastupdate => Date.new(2007, 4, 1)}, :lang => "ja"
    assert_html("ja/create_error.html")

    post :create, :article => {:title => "", :description => "", :lastupdate => Date.new(2007, 4, 1)}, :lang => "en"
    assert_html("en/create_error.html")
  end

  test "should show article" do
    get :show, :id => 1, :lang => "ja"

    assert_html("ja/show.html")
    assert_response :success
    assert_not_nil assigns(:article)
    assert assigns(:article).valid?
    get :show, :id => 1, :lang => "en"
    assert_html("en/show.html")
  end

  test "should get edit" do
    get :edit, :id => articles(:one).id
    assert_response :success
  end

  test "should update article" do
    put :update, :id => articles(:one).id, :article => {:title => "bbbbbbbbbb", :description => "CCCCCCCCCC" }
    assert_redirected_to article_path(assigns(:article))
  end

  test "should destroy article" do
    assert_difference('Article.count', -1) do
      delete :destroy, :id => articles(:one).id
    end

    assert_redirected_to articles_path
  end
end
