require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it { should have_many(:application_pets) }
    it { should have_many(:applications).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @application_1 = Application.create!(
      human_name: "Aziz Ansari",
      description: "Very funny, entertaining to dogs",
      street_address: "777 MasterOfNone Street",
      city: "Detroit",
      state: "MI",
      zip: "48103",
      status: "In Progress")
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
    @pet_4 = @shelter_1.pets.create(name: 'Pupper', breed: 'maltese', age: 8, adoptable: true)
    @pet_5 = @shelter_1.pets.create(name: 'Tot', breed: 'golden retriever', age: 2, adoptable: true)
    ApplicationPet.create!(application_id: @application_1.id, pet_id: @pet_1.id, status: "Pending")
    ApplicationPet.create!(application_id: @application_1.id, pet_id: @pet_2.id, status: "Approved")
    ApplicationPet.create!(application_id: @application_1.id, pet_id: @pet_3.id, status: "Rejected")
    ApplicationPet.create!(application_id: @application_1.id, pet_id: @pet_4.id, status: "Approved")
    ApplicationPet.create!(application_id: @application_1.id, pet_id: @pet_5.id, status: "Pending")
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2, @pet_4, @pet_5])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '.pending?' do 
      it 'returns true if the applications_pet status is pending' do 

        expect(@pet_1.pending?(@application_1.id)).to be(true)
        expect(@pet_2.pending?(@application_1.id)).to be(false)
      end
    end
    
    describe '.approved?' do 
      it 'returns true if the applications_pet status is approved' do 

        expect(@pet_1.approved?(@application_1.id)).to be(false)
        expect(@pet_2.approved?(@application_1.id)).to be(true)
      end
    end

    describe '.rejected?' do 
      it 'returns true if the applications_pet status is rejected' do 

        expect(@pet_3.rejected?(@application_1.id)).to be(true)
        expect(@pet_4.rejected?(@application_1.id)).to be(false)
      end
    end
  end
end
