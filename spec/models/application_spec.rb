require 'rails_helper'

RSpec.describe Application, type: :model do
  let!(:application) { Application.create!(
        human_name: "Brad Pitt",
        description: "Very rich, multiple homes, ample backyard space.",
        street_address: "123 Hollywood Blvd",
        city: "Los Angeles",
        state: "CA",
        zip: "90210",
        status: "Rejected")}

  let!(:application_2) { Application.create!(
        human_name: "Ricky Martin",
        description: "Lives la vida loca, regularly shakes bon bon",
        street_address: "600 Sunset Blvd",
        city: "New York",
        state: "NY",
        zip: "10210",
        status: "Accepted")}

  let!(:application_3) { Application.create!(
        human_name: "Vanessa Carlton",
        description: "Very rich, would walk 1,000 miles.",
        street_address: "555 Singersongwriter Street",
        city: "Los Angeles",
        state: "CA",
        zip: "89902",
        status: "In Progress")}

  let!(:application_4) { Application.create!(
        human_name: "Richard Branson",
        description: "Very, very rich, private island for pets.",
        street_address: "1 Necker Island",
        city: "Island",
        state: "BVI",
        zip: "VG1150",
        status: "Pending")}

  describe 'relationships' do
    it { should have_many(:application_pets) }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe 'attributes' do
    it 'exists' do
      expect(application).to be_a(Application)  
      expect(application.human_name).to eq("Brad Pitt")  
      expect(application.state).to eq("CA")  
      expect(application.status).to eq("Rejected")  
    end
  end

  describe 'validations' do 
    it { should validate_presence_of(:human_name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
  end

  describe '#can_add_pets?' do
    it 'is true if application is not rejected, accepted, or pending' do
      expect(application.can_add_pets?).to be false
      expect(application_2.can_add_pets?).to be false
      expect(application_3.can_add_pets?).to be true
      expect(application_4.can_add_pets?).to be false
    end
  end
end
