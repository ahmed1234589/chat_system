module Api
  module V1
    class ApplicationsController < ApplicationController
    def index
      applications = Application.all

      render json: ApplicationRepresenter.new(applications).as_json_arr
    end

    def show
      app = Application.find_by(token: params[:id])
      if app

        render json: ApplicationRepresenter.new(app).as_json, status: :found
      else
        render json: "#{params[:token]} is not found" ,status: :not_found
      end

    end

    def create
      application = Application.new(application_params)
      application.token = SecureRandom.hex(16).to_s
      application.chat_count = 0

      if application.save
        render json: ApplicationRepresenter.new(application).as_json, status: :created
      else
        render json: application.errors, status: :unprocessable_entity
      end
    end

    def update
      app = Application.find_by_token(params[:id])
      if app
        ActiveRecord::Base.transaction do
          app.lock!
          app.update(name: params[:name])
          app.save!
        end
        render json: "Application updated successfully." , status: :ok
      else
        render json: "Application is not found", status: :not_found
      end
    end

    private

    def application_params
      params.require(:application).permit(:name)
    end
    end
  end
end