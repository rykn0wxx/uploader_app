class Project < ApplicationRecord
  has_many :clients
  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 100 }
end
