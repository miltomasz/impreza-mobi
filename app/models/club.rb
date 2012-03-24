class Club < ActiveRecord::Base
  has_many :events
  belongs_to :city
end
