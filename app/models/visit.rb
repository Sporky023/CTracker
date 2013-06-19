class Visit < ActiveRecord::Base
  belongs_to :user
  belongs_to :country
  # attr_accessible :title, :body
end
