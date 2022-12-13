class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets
  has_many :applications, through: :application_pets

  def self.adoptable
    where(adoptable: true)
  end

  def shelter_name
    shelter.name
  end

  def pending?(application_id)
    app_pet_record = application_pets.find_by(
      application_id: application_id
    )
    app_pet_record.status == "Pending"
  end
end
