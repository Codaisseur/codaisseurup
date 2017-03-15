class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @registration = current_user.registrations.create(registration_params)

    redirect_to @registration.event, notice: "Thank you for registering!"
  end

  private

    def booking_params
      params.require(:registration).permit(:price, :guests_count, :event_id)
    end
end
