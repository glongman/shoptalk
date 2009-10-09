class Shop < ActiveRecord::Base
  validates_uniqueness_of :pin # really restrictive as there are only 4 digit pins allowed
end
