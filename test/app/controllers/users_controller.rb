class UsersController < ApplicationController
  def error_message
    @user = User.new
    @user.name = "foo"
    @user.lastupdate = "2007-01-01"
    @user.valid?

    @article = Article.new
    @article.valid?
  end
  
  def distance_of_time_in_words
  end

  def foo
  end
  private :foo
  before_init_gettext :foo
end
