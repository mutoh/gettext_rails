=begin
  gettext_rails/action_view/form_builder.rb - GetText for ActionView.

  Copyright (C) 2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.

  Original: gettext/lib/rails.rb from Ruby-GetText-Package-1.93.0

  $Id$
=end

module ActionView #:nodoc:
  module Helpers  #:nodoc:
    class FormBuilder
      include GetText
      
      def label_with_gettext(method, text = nil, options = {})
        text ||= s_("#{@object.class}|#{method.to_s.humanize}")
        @template.label(@object_name, method, text, options.merge(:object => @object))
      end
      alias_method_chain :label, :gettext
    end
  end
end
