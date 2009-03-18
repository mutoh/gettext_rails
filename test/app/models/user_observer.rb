class UserObserver < ActiveRecord::Observer

  def after_save(user)
    puts "after_save in UserObserver"
  end

end
