require 'rails_helper'

RSpec.describe 'the /admin/applications/:id show page', type: :feature do
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
        street_address: "777 MasterOfNone Street",
        city: "Detroit",
        state: "MI",
        zip: "48103",
        status: "In Progress")}

  let!(:application_3) { Application.create!(
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
  let!(:application_pets_5) { ApplicationPet.create!(application_id: application_3.id, pet_id: pet_1.id) }

  describe 'approving a pet for adoption' do
    it 'shows a list of every pet on that application' do
      visit "/admin/applications/#{application_2.id}"      
      
      expect(page).to have_content(pet_1.name)
      expect(page).to have_content(pet_2.name)
      expect(page).to_not have_content(pet_3.name)
    end

    it 'has a button next to each pet to approve that specific pet' do
      visit "/admin/applications/#{application_2.id}"      

      expect(page).to have_button("Approve #{pet_1.name}")
      expect(page).to have_button("Approve #{pet_2.name}")
    end

    it 'returns to the /admin/applications/:id show page and approve button is gone' do
      visit "/admin/applications/#{application_2.id}"      

      expect(page).to have_button("Approve Lucky")
      
      click_button("Approve Lucky")
      
      expect(page).to_not have_button("Approve Lucky")
      expect(page).to have_content("Approved!")
    end
  end

  #us14
  describe 'multiple approved pets on different applications' do
    it 'allows a pet to be approved on one application while not affecting another with same pet' do
      visit "/admin/applications/#{application_2.id}"      

      expect(page).to have_button("Approve Lucky")

      click_button("Approve Lucky")

      expect(page).to_not have_button("Approve Lucky")
      expect(page).to have_content("Lucky Approved!")

      visit "/admin/applications/#{application_3.id}"      

      expect(page).to have_button("Approve Lucky")
      click_button("Approve Lucky")

      expect(page).to_not have_button("Approve Lucky")
      expect(page).to have_content("Lucky Approved!")
    end

    it 'allows a pet can be declined on one application and approved on another' do
      visit "/admin/applications/#{application_2.id}"      

      # change this depending on button name
      expect(page).to have_button("Decline Lucky")

      click_button("Decline Lucky")

      expect(page).to_not have_button("Decline Lucky")
      expect(page).to have_content("Lucky Declined!")

      visit "/admin/applications/#{application_3.id}"      

      expect(page).to have_button("Approve Lucky")
      click_button("Approve Lucky")

      expect(page).to_not have_button("Approve Lucky")
      expect(page).to have_content("Lucky Approved!")
    end
  end
end