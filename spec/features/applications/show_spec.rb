require 'rails_helper'

RSpec.describe 'the application show page /applications/:id', type: :feature do
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

  describe 'application show page' do
    it 'displays the attributes of a single application' do
      visit "/applications/#{application.id}"
      # save_and_open_page
      expect(page).to have_content(application.human_name)
      expect(page).to have_content("123 Hollywood Blvd")
      expect(page).to have_content(application.description)
      expect(page).to have_content(application.city)
      expect(page).to have_content(application.state)
      expect(page).to have_content(application.zip)
      expect(page).to have_content(application.status)

      visit "/applications/#{application_2.id}"

      expect(page).to have_content(application_2.human_name)
      expect(page).to have_content("777 Lucky Street")
      expect(page).to have_content(application_2.description)
      expect(page).to have_content(application_2.city)
      expect(page).to have_content(application_2.state)
      expect(page).to have_content(application_2.zip)
      expect(page).to have_content(application_2.status)
    end
    
    it 'displays all pets for which the application is applying' do
      visit "/applications/#{application.id}"

      expect(page).to have_content("Animals Applied For")
      expect(page).to have_link("Lucky", href: "/pets/#{pet_1.id}")
      expect(page).to have_link("Lobster", href: "/pets/#{pet_2.id}")
      expect(page).to have_link("Sylvester", href: "/pets/#{pet_3.id}")

      visit "/applications/#{application_2.id}"

      expect(page).to have_link("Lucky", href: "/pets/#{pet_1.id}")
      expect(page).to have_link("Lobster", href: "/pets/#{pet_2.id}")

      expect(page).to_not have_link("Sylvester", href: "/pets/#{pet_3.id}")
    end

    #us4
    describe 'searching for pets for application' do
      it "shows an 'Add a Pet to this Application' section when not yet submitted" do
        visit "/applications/#{application_2.id}" # pending application

        expect(application_2.can_add_pets?).to be true 
        expect(page).to have_content("Add a Pet to this Application")

        visit "/applications/#{application.id}" # rejected application
        expect(application.can_add_pets?).to be false 
        expect(page).to_not have_content("Add a Pet to this Application")
      end

      it 'has a text search field to search for pets by name' do
        visit "/applications/#{application_2.id}" # pending application

        expect(application_2.can_add_pets?).to be true 
        expect(page).to have_field("Pet Name")
        expect(page).to have_button("Search")

        visit "/applications/#{application.id}" # rejected application
        expect(application.can_add_pets?).to be false 
        expect(page).to_not have_field("Pet Name")
        expect(page).to_not have_button("Search")
      end
      
      it 'returns to application show page after clicking submit and has matching pet name' do
        visit "/applications/#{application_2.id}" # pending application

        expect(application_2.can_add_pets?).to be true 
        expect(page).to have_field("Pet Name")
        expect(page).to have_button("Search")

        fill_in("Pet Names:", with: "Sylvester")
        click_button("Search")

        expect(page).to have_content("Sylvester")
        expect(page).to_not have_content("Vester")
        expect(current_path).to eq("/applications/#{application_2.id}")
      end
      
      #us5
      it "has a 'Adopt this Pet' button next to all pet names returned from search" do
        visit "/applications/#{application_2.id}" # pending application

        fill_in("Pet Names:", with: "Sylvester")
        click_button("Search")

        expect(current_path).to eq("/applications/#{application_2.id}")
        expect(page).to have_content("Sylvester")
        expect(page).to have_button("Adopt this Pet")
      end

      it "clicking 'Adopt this Pet' refreshes page and adds that pet to application" do
        visit "/applications/#{application_2.id}" # pending application

        fill_in("Pet Names:", with: "Sylvester")
        click_button("Search")

        expect(current_path).to eq("/applications/#{application_2.id}")
        expect(page).to have_content("Sylvester")
        expect(page).to have_button("Adopt this Pet")

        click_button("Adopt this Pet")

        expect(current_path).to eq("/applications/#{application_2.id}")
        expect(page).to have_content("Sylvester")
        expect("Sylvester").to appear_before("Add a Pet to this Application")
      end
    end

    describe 'application submission' do 
      it 'has a section to describe why you would be a good owner and a submit button if there are pets on the application' do 
        application_3.pets << pet_1
        application_3.pets << pet_2
        application_3.pets << pet_3 

        visit "/applications/#{application_3.id}"

        expect(page).to have_content("Status: In Progress")
        expect(page).to have_content("Submit Application")
        expect(page).to have_content("Why would you make a good pet owner?")

        fill_in :description, with: "I have money"
        click_button "Submit"

        expect(current_path).to eq("/applications/#{application_3.id}")
        expect(page).to have_content("Description: I have money")
        expect(page).to have_content("Status: Pending")
        expect(page).to_not have_content("Submit Application")
        expect(page).to_not have_content("Why would you make a good pet owner?")
      end

      it 'does not have a submit application section if there are no pets on the application' do 
        visit "/applications/#{application_3.id}"

        expect(page).to_not have_content("Submit Application")
        expect(page).to_not have_content("Why would you make a good pet owner?")
      end
    end

    describe 'search functionality' do
      it 'can find results with partial match' do
        visit "/applications/#{application_3.id}"

        fill_in("Pet Names:", with: "ter")
        click_button("Search")
        
        expect(current_path).to eq("/applications/#{application_3.id}")
        expect(page).to have_content("Sylvester")
        expect(page).to have_content("Lobster")
        expect(page).to have_content("Vester")
        expect(page).to_not have_content("Rocky")
      end

      it 'can find results with partial match case insensitive' do
        visit "/applications/#{application_3.id}"

        fill_in("Pet Names:", with: "ROckY")
        click_button("Search")
        
        expect(page).to have_content("Rocky")
      end
    end
  end
end