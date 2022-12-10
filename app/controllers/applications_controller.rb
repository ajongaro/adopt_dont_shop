class ApplicationsController < ApplicationController

  def new
    
  end

  def show
    @application = Application.find(params[:id])
  end

  def create 
    application = Application.new(
      permitted_params.merge({status: "In Progress"})
    )

    if application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to '/applications/new'
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  private

  def permitted_params
    params.permit(
      :human_name,
      :street_address,
      :city,
      :state,
      :zip,
      :description
    )
  end
end