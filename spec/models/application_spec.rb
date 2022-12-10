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
    it { should validate_presence_of(:description) }
  end
end
