require 'rails_helper'

RSpec.describe 'Admins shelters index' do 
  let!(:application) { Application.create!(
    human_name: "Brad Pitt",
    description: "Very rich, multiple homes, ample backyard space.",
    street_address: "123 Hollywood Blvd",
    city: "Los Angeles",
    state: "CA",
    zip: "90210",
    status: "Rejected")}

  let!(:application_2) { Application.create!(
    human_name: "Aziz Ansari",
    description: "Very funny, entertaining to dogs",
    street_address: "777 Lucky Street",
    city: "Seattle",
    state: "WA",
    zip: "98101",
    status: "In Progress")}

  let!(:application_3) { Application.create!(
    human_name: "Bart Bluck",
    street_address: "777 Lucky Street",
    city: "Seattle",
    state: "WA",
    zip: "98101",
    status: "In Progress")}

  let!(:application_4) { Application.create!(
    human_name: "Ricky Martin",
    description: "Lives la vida loca, regularly shakes bon bon",
    street_address: "600 Sunset Blvd",
    city: "New York",
    state: "NY",
    zip: "10210",
    status: "Pending")}

  let!(:application_5) { Application.create!(
    human_name: "Vanessa Carlton",
    description: "Very rich, would walk 1,000 miles.",
    street_address: "555 Singersongwriter Street",
    city: "Los Angeles",
    state: "CA",
    zip: "89902",
    status: "Pending")}

  let!(:application_6) { Application.create!(
    human_name: "Richard Branson",
    description: "Very, very rich, private island for pets.",
    street_address: "1 Necker Island",
    city: "Island",
    state: "BVI",
    zip: "VG1150",
    status: "Pending")}

  let!(:shelter) { Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9) }
  let!(:shelter_2) { Shelter.create!(name: 'Paws and Tails', city: 'San Francisco CA', foster_program: true, rank: 7) }
  let!(:shelter_3) { Shelter.create!(name: 'Boulder Humane Society', city: 'Boulder CO', foster_program: true, rank: 6) }
  let!(:shelter_4) { Shelter.create!(name: 'Denver Humane Society', city: 'Denver CO', foster_program: true, rank: 4) }

  let!(:pet_1) { Pet.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucky', shelter_id: shelter.id) }
  let!(:pet_2) { Pet.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id) }
  let!(:pet_3) { Pet.create!(adoptable: true, age: 1, breed: 'domestic shorthair', name: 'Sylvester', shelter_id: shelter_2.id) }
  let!(:pet_4) { Pet.create!(adoptable: true, age: 6, breed: 'poodle mix', name: 'Vester', shelter_id: shelter_2.id) }
  let!(:pet_5) { Pet.create!(adoptable: true, age: 9, breed: 'bully', name: 'Rocky', shelter_id: shelter_3.id) }

  let!(:application_pets) { ApplicationPet.create!(application_id: application.id, pet_id: pet_1.id) }
  let!(:application_pets_2) { ApplicationPet.create!(application_id: application.id, pet_id: pet_2.id) }
  let!(:application_pets_3) { ApplicationPet.create!(application_id: application_4.id, pet_id: pet_3.id) }
  let!(:application_pets_4) { ApplicationPet.create!(application_id: application_6.id, pet_id: pet_1.id) }
  let!(:application_pets_5) { ApplicationPet.create!(application_id: application_6.id, pet_id: pet_2.id) }

  describe 'shelters index' do
    it 'displays the shelters in reverse alphabetical order' do
      visit '/admin/shelters'
      
      within('section#all') do
        expect('Paws and Tails').to appear_before('Mystery Building')
        expect('Mystery Building').to appear_before('Denver Humane Society')
        expect('Denver Humane Society').to appear_before('Boulder Humane Society')
        expect('Boulder Humane Society').to_not appear_before('Denver Humane Society')
      end
    end

    it 'displays shelters that have pending applications' do 
      visit '/admin/shelters'

      within('section#pending') do
        expect(page).to have_content(shelter_2.name)
        expect(page).to have_content(shelter.name)
        expect(page).to_not have_content(shelter_3.name)
      end
    end
  end
end