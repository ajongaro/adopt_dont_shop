require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  let!(:application) { Application.create!(
        human_name: "Aziz Ansari",
        description: "Very funny, entertaining to dogs",
        street_address: "777 MasterOfNone Street",
        city: "Detroit",
        state: "MI",
        zip: "48103",
        status: "In Progress")}

  let!(:application_2) { Application.create!(
        human_name: "Bart Bluck",
        street_address: "777 Lucky Street",
        city: "Seattle",
        state: "WA",
        zip: "98101",
        status: "In Progress")}

  let!(:shelter) { Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9) }
  let!(:shelter_2) { Shelter.create!(name: 'Paws and Tails', city: 'San Francisco CA', foster_program: true, rank: 7) }

  let!(:pet_1) { Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucky', shelter_id: shelter.id) }
  let!(:pet_2) { Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id) }
  let!(:pet_3) { Pet.create!(adoptable: true, age: 1, breed: 'domestic shorthair', name: 'Sylvester', shelter_id: shelter_2.id) }
  let!(:pet_4) { Pet.create!(adoptable: true, age: 6, breed: 'poodle mix', name: 'Vester', shelter_id: shelter_2.id) }
  let!(:pet_5) { Pet.create!(adoptable: true, age: 9, breed: 'bully', name: 'Rocky', shelter_id: shelter_2.id) }
  
  let!(:application_pets) { ApplicationPet.create!(application_id: application.id, pet_id: pet_1.id) }
  let!(:application_pets_2) { ApplicationPet.create!(application_id: application.id, pet_id: pet_2.id) }
  let!(:application_pets_3) { ApplicationPet.create!(application_id: application.id, pet_id: pet_3.id) }
  let!(:application_pets_4) { ApplicationPet.create!(application_id: application_2.id, pet_id: pet_1.id) }
  let!(:application_pets_5) { ApplicationPet.create!(application_id: application_2.id, pet_id: pet_2.id) }
  describe 'relationships' do
    it { should belong_to :application }
    it { should belong_to :pet }
  end

  describe 'the model' do
    it 'exists' do
      expect(application_pets).to be_a(ApplicationPet)
      expect(application_pets.application_id).to eq(application.id)
      expect(application_pets.pet_id).to eq(pet_1.id)
    end
  end
end