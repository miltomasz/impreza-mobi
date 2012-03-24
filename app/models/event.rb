class Event < ActiveRecord::Base
  belongs_to :club
  attr_accessor :average_note
  has_many :comments
end
