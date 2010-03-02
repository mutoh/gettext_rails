=begin
  gettext_rails/action_view/date_helper.rb - GetText for ActionView.

  Copyright (C) 2005-2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.

  Original: gettext/lib/rails.rb from Ruby-GetText-Package-1.93.0

=end

module ActionView #:nodoc:
  module Helpers  #:nodoc:
 
    module DateHelper #:nodoc: all
      include GetText
      bindtextdomain "gettext_rails"

      alias distance_of_time_in_words_without_gettext_rails distance_of_time_in_words #:nodoc:

      # This is FAKE constant. The messages are found by rgettext as the msgid. 
      MESSAGESS = [N_('less than 5 seconds'), N_('less than 10 seconds'), N_('less than 20 seconds'),
                   N_('half a minute'), N_('less than a minute'), N_('about 1 month'), 
                   N_('about 1 year')]
      NMINUTES = [/^(\d+) minutes?$/, Nn_('1 minute', '%{num} minutes')]
      NHOURS   = [/^about (\d+) hours?$/, Nn_('about 1 hour', 'about %{num} hours')]
      NDAYS    = [/^(\d+) days?$/, Nn_('1 day', '%{num} days')]
      AMONTHS  = [/^about (\d+) months?$/, Nn_('about 1 month', 'about %{num} months')]
      NMONTHS  = [/^(\d+) months?$/, Nn_('1 month', '%{num} months')]
      AYEARS  = [/^about (\d+) years?$/, Nn_('about 1 year', 'about %{num} years')]
      NYEARS  = [/^over (\d+) years?$/, Nn_('over 1 year', 'over %{num} years')]
      ALYEARS  = [/^almost (\d+) years?$/, Nn_('almost 1 year', 'almost %{num} years')]

      def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
        msg = distance_of_time_in_words_without_gettext_rails(from_time, to_time, include_seconds)
        match = false
        [NMINUTES, NHOURS, NDAYS, AMONTHS, NMONTHS, AYEARS, NYEARS, ALYEARS].each do |regexp, nn|
          if regexp =~ msg
            match = true
            msg = n_(nn, $1.to_i) % {:num => $1}
            break
          end
        end
        match ? msg : _(msg)
      end
    end

  end
end
