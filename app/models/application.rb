class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets

  validates_presence_of :human_name,
                        :street_address,
                        :city,
                        :state,
                        :zip

  def can_add_pets?
    status == "In Progress"
  end
end