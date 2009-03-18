ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  unless defined? RESULT_DIR
    RESULT_DIR = File.join(File.dirname(__FILE__), "result/")
  end

  def save_data(path, data)
    complete_path = File.join(RESULT_DIR, path)
    unless File.exist?(complete_path)
      base_dir = File.dirname(complete_path)
      FileUtils.mkdir_p(base_dir) unless File.exist?(base_dir)
      open(complete_path, "w"){|io| io.write data}
    end
    complete_path
  end

  def save_html(path)
    save_data(path, @response.body)
  end

  def assert_html(path)
    complete_path = save_html(path)
    ary = IO.readlines(complete_path)
    i = 0
    @response.body.each_line{|line|
      assert_equal ary[i], line
      i += 1
    }
  end

  def assert_mail(path, data)
    complete_path = save_data(path, data)
    assert_equal IO.read(complete_path), data
  end

  def mimepart(data)
    data.gsub(/^--mimepart_.*$/, "--mimepart").
      gsub(/boundary\=mimepart_(.*)$/, "boundary=mimepart")
  end

  def assert_multipart(path, data)
    complete_path = save_data(path, data)
    target = mimepart(IO.read(complete_path))
    data = mimepart(data)
    assert_equal target, data
  end

  # Add more helper methods to be used by all tests here...
end
