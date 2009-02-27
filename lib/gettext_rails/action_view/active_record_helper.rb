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

        bindtextdomain("rails")

        @error_message_title = Nn_("%{num} error prohibited this %{record} from being saved", 
                                   "%{num} errors prohibited this %{record} from being saved")
        @error_message_explanation = Nn_("There was a problem with the following field:", 
                                         "There were problems with the following fields:")

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
          @error_message_title = [single_msg, plural_msg]
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
          @error_message_explanation = [single_msg, plural_msg]
        end

        # 
        def error_messages_for(instance, objects, object_names, count, options)
          record = ActiveRecord::Base.human_attribute_table_name_for_error(options[:object_name] || object_names[0].to_s)

          html = {}
          [:id, :class].each do |key|
            if options.include?(key)
              value = options[key] 
              html[key] = value unless value.blank?
            else
              html[key] = 'errorExplanation'
            end
          end

          if options[:message_title]
            header_message = instance.error_message(options[:message_title], count) % {:num => count, :record => record}
          else
            header_message = n_(@error_message_title, count) % {:num => count, :record => record}
          end
          if options[:message_explanation]
            message_explanation = instance.error_message(options[:message_explanation], count) % {:num => count}
          else
            message_explanation = n_(@error_message_explanation, count) % {:num => count}
          end

          error_messages = objects.map {|object| object.errors.full_messages.map {|msg| instance.content_tag(:li, msg) } }
          
          instance.content_tag(:div,
                               instance.content_tag(options[:header_tag] || :h2, header_message) <<
                               instance.content_tag(:p, message_explanation) <<
                               instance.content_tag(:ul, error_messages),
                               html
                               )
        end
      end

      def error_message(msg, count) #:nodoc:
        ngettext(msg, count)
      end

      alias error_messages_for_without_localize error_messages_for #:nodoc:

      # error_messages_for overrides original method with localization.
      # And also it extends to be able to replace the title/explanation of the header of the error dialog. (Since 1.90)
      # If you want to override these messages in the whole application, 
      #    use ActionView::Helpers::ActiveRecordHelper::L10n.set_error_message_(title|explanation) instead.
      # * :message_title - the title of message. Use Nn_() to path the strings for singular/plural.
      #                       e.g. Nn_("%{num} error prohibited this %{record} from being saved", 
      # 			       "%{num} errors prohibited this %{record} from being saved")
      # * :message_explanation - the explanation of message
      #                       e.g. Nn_("There was a problem with the following field:", 
      #                                "There were %{num} problems with the following fields:")
      def error_messages_for(*params)
        options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
        if object = options.delete(:object)
          objects = [object].flatten
        else
          objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
        end
        object_names = params.dup
        count   = objects.inject(0) {|sum, object| sum + object.errors.count }
        if count.zero?
          ''
        else
          L10n.error_messages_for(self, objects, object_names, count, options)
        end
      end
    end
  end
end
