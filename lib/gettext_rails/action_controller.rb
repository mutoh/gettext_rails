=begin
  gettext_rails/action_controller.rb - GetText for ActionController.

  Copyright (C) 2005-2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.

  Original: gettext/lib/rails.rb from Ruby-GetText-Package-1.93.0

  $Id$
=end
require 'gettext/cgi'
require 'locale_rails'
require 'action_controller'

module ActionController #:nodoc:
  class Base
    include GetText

    # Append a block which is called before initializing gettext on the each WWW request.
    #
    # (e.g.1)
    #   class ApplicationController < ActionController::Base
    #     before_init_gettext{|controller|
    #       p "before_init_gettext is called."
    #     }
    #     init_gettext "myapp"
    #     # ...
    #   end
    #
    # (e.g.2)
    #   class ApplicationController < ActionController::Base
    #     def sample_foo
    #       p "sample_foo is called."
    #     end
    #     before_init_gettext :sample_foo
    #     init_gettext "myapp"
    #     # ...
    #   end
    def self.before_init_gettext(*filters, &block)
      before_init_locale(*filters, &block)
    end

    # Append a block which is called after initializing gettext on the each WWW request.
    #
    # The GetText.locale is set the locale which bound to the textdomains
    # when gettext is initialized.
    #
    # (e.g.1)
    #   class ApplicationController < ActionController::Base
    #     after_init_gettext {|controller|
    #       L10nClass.new(GetText.locale)
    #     }
    #     init_gettext "foo"
    #     # ...
    #   end
    #
    # (e.g.2)
    #   class ApplicationController < ActionController::Base
    #     def sample_foo
    #       L10nClass.new(GetText.locale)
    #     end
    #     after_init_gettext :sample_foo
    #     init_gettext "foo"
    #     # ...
    #   end
    def self.after_init_gettext(*filters, &block)
      after_init_locale(*filters, &block)
    end

    # Bind a 'textdomain' to all of the controllers/views/models. Call this instead of GetText.bindtextdomain.
    # * textdomain: the textdomain
    # * options: options as a Hash.
    #   * :charset - the output charset. Default is "UTF-8"
    #   * :locale_path - the path to locale directory. Default is {RAILS_ROOT}/locale or {plugin root directory}/locale.
    #
    # locale is searched the order by params["lang"] > "lang" value of QUERY_STRING > 
    # "lang" value of Cookie > HTTP_ACCEPT_LANGUAGE value > Default locale(en). 
    # And the charset is set order by "the argument of bindtextdomain" > HTTP_ACCEPT_CHARSET > Default charset(UTF-8).
    # Refer Ruby-Locale for more details.
    #
    # If you want to separate the textdomain each controllers, you need to call this function in the each controllers.
    #
    # app/controller/blog_controller.rb:
    #  class BlogController < ApplicationController
    #    init_gettext "blog"
    #      :
    #    end
    def self.init_gettext(domainname, options = {})
      opt = {:charset => "UTF-8"}.merge(options)

      set_output_charset(opt[:charset])
      locale_path = opt[:locale_path]
      unless locale_path
        cal = caller[0]
        if cal =~ /app.controllers/
          # Don't use RAILS_ROOT first, for RailsEngines. 
          locale_path = File.join(cal.split(/app.controllers/)[0] + "locale")
        else
          locale_path = File.join(RAILS_ROOT, "locale")
        end
      end

      bindtextdomain(domainname, {:path => locale_path})

      if defined? ActiveRecord::Base
        textdomain_to(ActiveRecord::Base, domainname) 
        textdomain_to(ActiveRecord::Validations, domainname)
      end
      textdomain_to(ActionView::Base, domainname) if defined? ActionView::Base
      textdomain_to(ApplicationHelper, domainname) if defined? ApplicationHelper
      textdomain_to(ActionMailer::Base, domainname) if defined? ActionMailer::Base
      textdomain_to(ActionView::Helpers, domainname) if defined? ActionView::Helpers
    end

  end

end
