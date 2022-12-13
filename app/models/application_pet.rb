class ApplicationPet < ApplicationRecord
  belongs_to :application 
  belongs_to :pet 
  validates_presence_of :status
  validates_presence_of :application_id
  validates_presence_of :pet_id
end