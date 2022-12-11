require 'rails_helper'

RSpec.describe 'application new page' do
  it 'displays the new application form' do
    visit '/applications/new'

    expect(page).to have_content("Pet Adoption Application")
    expect(find('form')).to have_content('Human name')
    expect(find('form')).to have_content('Street address')
    expect(find('form')).to have_content('City')
    expect(find('form')).to have_content('State')
    expect(find('form')).to have_content('Zip')
  end

  it 'creates a new application form to submit' do 
    visit '/applications/new'

    fill_in 'Human name', with: "Brad Pitt"
    fill_in 'Street address', with: "123 Hollywood Blvd"
    fill_in 'City', with: "Los Angeles"
    fill_in 'State', with: "CA"
    fill_in 'Zip', with: "90210"
    click_button 'Submit'

    application = Application.last

    expect(page).to have_current_path("/applications/#{application.id}")
    expect(page).to have_content("Status: In Progress")
  end

  it 'returns an error message for a partially completed out form' do 
    visit '/applications/new'

    fill_in 'Human name', with: "Brad Pitt"
    fill_in 'Street address', with: "123 Hollywood Blvd"
    fill_in 'City', with: "Los Angeles"
    click_button 'Submit'

    expect(page).to have_content("State can't be blank")
    expect(page).to have_content("Zip can't be blank")
  end
end