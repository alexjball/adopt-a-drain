# frozen_string_literal: true

class ThingsController < ApplicationController
  respond_to :json

  def show
    @things = Thing.find_closest(params[:lat],
                                 params[:lng],
                                 params[:limit] || 10,
                                 helpers.current_city)
    if @things.blank?
      render(json: {errors: {address: [t('errors.not_found', thing: t('defaults.thing'))]}}, status: :not_found)
    else
      respond_with @things
    end
  end

  def update
    @thing = Thing.find(params[:id])
    if @thing.update(thing_params)
      send_adoption_email(@thing.user, @thing) if @thing.adopted?

      respond_with @thing
    else
      render(json: {errors: @thing.errors}, status: :internal_server_error)
    end
  end

private

  def send_adoption_email(user, thing)
    case user.things.count
    when 1
      ThingMailer.first_adoption_confirmation(thing).deliver_later
    when 2
      ThingMailer.second_adoption_confirmation(thing).deliver_later
    end
  end

  def thing_params
    params.require(:thing).permit(:adopted_name, :user_id)
  end
end
