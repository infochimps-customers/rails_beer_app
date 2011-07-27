class Beer < ActiveRecord::Base
  attr_accessible :title, :description, :price, :image_link, :metro_name

  validates :title,       :presence => true
  validates :description, :presence => true
  validates :price,       :presence => true, :numericality => { :greater_than => 0 }
  validates :image_link,  :presence => true

  def self.default_beer
    first
  end
  
end
