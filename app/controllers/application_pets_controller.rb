class ApplicationPetsController < ApplicationController
  def new
    # Is there a way to use strong params for non-matching params?
    ApplicationPet.create!(application_id: params[:application_id], pet_id: params[:id])
    redirect_to "/applications/#{params[:application_id]}"
  end

  def update
    application_pet = ApplicationPet.where(application_id: params[:id], pet_id: params[:pet_id])
    application_pet.update(status: "Approved")
    redirect_to "/admin/applications/#{params[:application_id]}"
  end
end