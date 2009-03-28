=begin
  gettext_rails/action_mailer.rb - GetText for ActionMailer.

  Copyright (C) 2005-2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.

  Original: gettext/lib/rails.rb from Ruby-GetText-Package-1.93.0

  $Id$
=end

if defined? ActionMailer
  module ActionMailer #:nodoc:
    class Base #:nodoc:
      include GetText
      
      def base64(text, charset="iso-2022-jp", convert=true)
	if convert
	  if charset == "iso-2022-jp"
	    text = NKF.nkf('-j -m0', text)
          end
	end
	text = TMail::Base64.folding_encode(text)
	"=?#{charset}?B?#{text}?="
      end
      
      def create_with_gettext!(*arg) #:nodoc:
	create_without_gettext!(*arg)
	if Locale.get.language == "ja"
	  require 'nkf'
	  @mail.subject = base64(@mail.subject)
	  part = @mail.parts.empty? ? @mail : @mail.parts.first
	  if part.content_type == 'text/plain'
	    part.charset = 'iso-2022-jp'
	    part.body = NKF.nkf('-j', part.body)
	  end
	end
        @mail
      end
      alias_method_chain :create!, :gettext
    end
  end
end
