class Api::EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    render status: 200, json: {
      events: Event.all
    }.to_json
  end

  def show
    event = Event.find(params[:id])

    render status: 200, json: {
      event: event
    }.to_json
  end

  def create
    event = Event.new(event_params)

    if event.save
      render status: 201, json: {
        message: "Event successfully created",
        event: event
      }.to_json
    else
      render status: 422, json: {
        errors: event.errors
      }.to_json
    end
  end

  private
    def event_params
      params.require(:event).permit(:name, :description, :location, :includes_food, :includes_drinks, :price, :starts_at, :ends_at, :capacity, :active, category_ids: [])
    end
end
