=begin
  gettext_rails/action_view/active_record_helper.rb- GetText for ActionView.

  Copyright (C) 2005-2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.

  Original: gettext/lib/rails.rb from Ruby-GetText-Package-1.93.0

  $Id$
=end

module ActionView #:nodoc:
  module Helpers  #:nodoc:
    module ActiveRecordHelper #:nodoc: all
      module L10n
        # Separate namespace for textdomain
        include GetText

        bindtextdomain "gettext_rails"

        @@error_message_headers ={
          :header => Nn_("%{num} error prohibited this %{record} from being saved", 
                         "%{num} errors prohibited this %{record} from being saved"),
          :body => Nn_("There was a problem with the following field:", 
                     "There were problems with the following fields:")
        }
        
        module_function
        # call-seq:
        # set_error_message_title(msgs)
        #
        # Sets a your own title of error message dialog.
        # * msgs: [single_msg, plural_msg]. Usually you need to call this with Nn_().
        # * Returns: [single_msg, plural_msg]
        def set_error_message_title(msg, plural_msg = nil)
          if msg.kind_of? Array
            single_msg = msg[0]
            plural_msg = msg[1]
          else
            single_msg = msg
          end
          @@error_message_headers[:header] = [single_msg, plural_msg]
        end
        
        # call-seq:
        # set_error_message_explanation(msg)
        #
        # Sets a your own explanation of the error message dialog.
        # * msg: [single_msg, plural_msg]. Usually you need to call this with Nn_().
        # * Returns: [single_msg, plural_msg]
        def set_error_message_explanation(msg, plural_msg = nil)
          if msg.kind_of? Array
            single_msg = msg[0]
            plural_msg = msg[1]
          else
            single_msg = msg
          end
          @@error_message_headers[:body] = [single_msg, plural_msg]
        end

        def error_message(key, model, count) #:nodoc:
          return nil if key.nil?
           
          if key.kind_of? Symbol
            msgids = @@error_message_headers[key]
          else
            key << key[0] if (key.is_a?(Array) && key.length==1) 
            key = [key, key] if key.is_a? String

            msgids = key
          end

          model = _(model)
          if msgids
            ngettext(msgids, count) % {:num => count, :count => count, 
              :record => model, :model => model} # :num, :record are for backward compatibility.
          else
            nil
          end
        end

      end

      def error_messages_for_with_gettext_rails(*params) #:nodoc:
        models = params.select{|param| ! param.kind_of? Hash}
        options = params.extract_options!.symbolize_keys

        header_message = (options.has_key?(:header_message) || options.has_key?(:message_title)) ? (options[:header_message] || options[:message_title]) : (:header)
        message = (options.has_key?(:message) || options.has_key?(:message_explanation)) ? (options[:message] || options[:message_explanation]) :  (:body)

        object = options[:object]
        if object
          objects = [object].flatten
        else
          objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
        end
        count  = objects.inject(0) {|sum, object| sum + object.errors.count }

        options[:object_name] ||= params.first
        normalized_model = options[:object_name].to_s.gsub('_', ' ')
        
        #accept nil's as messages to hide message
        options[:header_message] = L10n.error_message(header_message, normalized_model, count)
        options[:message] = L10n.error_message(message, normalized_model, count)

        new_params = models << options
        error_messages_for_without_gettext_rails(*new_params)
      end
      alias_method_chain :error_messages_for, :gettext_rails
    end
  end
end
