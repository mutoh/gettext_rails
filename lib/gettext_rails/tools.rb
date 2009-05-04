=begin
  tools.rb - Utility functions

  Copyright (C) 2009 Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.
=end

require 'gettext_activerecord/tools'

module GetText
  extend self

  alias :create_mofiles_org :create_mofiles #:nodoc:

  # Rails version of create_mofiles. This sets mo_root "./locale" then
  # call original create_mofiles.
  def create_mofiles(options = {})
    opts = {:verbose => true, :mo_root => "./locale"}
    create_mofiles_org(opts)
  end

end
