class Resume < ActiveRecord::Base # represents a résumé
  belongs_to :user
end
