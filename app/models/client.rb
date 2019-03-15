class Client < ApplicationRecord
  belongs_to :project
  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 100 }
end
