class ApplicationsController < ApplicationController

  def new
    
  end

  def show
    @application = Application.find(params[:id])

    if params[:query] 
      @search_results = Pet.search(params[:query])
    end

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

  def update 
    application = Application.find(params[:id])
    application.update(
      description: params[:description], 
      status: "Pending"
    )

    redirect_to "/applications/#{application.id}"
  end

  private

  def permitted_params
    params.permit(
      :human_name,
      :street_address,
      :city,
      :state,
      :zip
    )
  end
end