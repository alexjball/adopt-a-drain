# frozen_string_literal: true

class UsersController < Devise::RegistrationsController
  def edit
    render('sidebar/edit_profile', layout: 'sidebar')
  end

  def update # rubocop:disable Metrics/AbcSize
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    if update_resource(resource, account_update_params)
      yield resource if block_given?
      sign_in(resource_name, resource, bypass_sign_in: true)
      flash[:notice] = 'Profile updated!'
      redirect_to(controller: 'sidebar', action: 'search')
    else
      clean_up_passwords(resource)
      render(json: {errors: resource.errors}, status: :internal_server_error)
    end
  end

  def create # rubocop:disable Metrics/AbcSize
    build_resource(sign_up_params)
    resource.city_domain = helpers.current_city
    if resource.save
      yield resource if block_given?
      sign_in(resource_name, resource)
      render(json: resource)
    else
      clean_up_passwords(resource)
      render(json: {errors: resource.errors}, status: :internal_server_error)
    end
  end

private

  def sign_up_params
    params.require(:user).permit(:email, :first_name, :last_name, :organization, :password, :password_confirmation, :sms_number, :voice_number)
  end

  def account_update_params
    params.require(:user).permit(:address_1, :address_2, :city, :current_password, :email, :first_name, :last_name, :organization, :password, :password_confirmation, :remember_me, :sms_number, :state, :voice_number, :zip)
  end
end
