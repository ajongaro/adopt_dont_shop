class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates_presence_of :human_name,
                        :street_address,
                        :city,
                        :state,
                        :zip,
                        :description
  def can_add_pets?
    application = self.status
    ["In Progress", "Pending"].include?(application)  
  end
end