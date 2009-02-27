=begin
  gettext_rails.rb- GetText for "Ruby on Rails"

  Copyright (C) 2005-2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.

  Original: gettext/lib/rails.rb from Ruby-GetText-Package-1.93.0

  $Id$
=end

require 'gettext_rails/action_controller.rb'
require 'gettext_rails/action_view.rb'
require 'gettext_rails/action_mailer.rb'
require 'gettext_rails/version.rb'

begin
  Rails::Info.property("GetText version") do 
    GetText::VERSION 
  end
  Rails::Info.property("GetText for Rails version") do 
    GetTextRails::VERSION 
  end
rescue Exception
  $stderr.puts "GetText's Rails::Info is not found." if $DEBUG
end

if ::RAILS_ENV == "development"
  GetText::TextDomainManager.cached = false
end

