# frozen_string_literal: true

class User < ApplicationRecord
  include ActiveModel::ForbiddenAttributesProtection
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable
  before_validation :remove_non_digits_from_phone_numbers
  has_many :reminders_from, class_name: 'Reminder', foreign_key: :from_user_id, inverse_of: :from_user, dependent: :destroy
  has_many :reminders_to, class_name: 'Reminder', foreign_key: :to_user_id, inverse_of: :to_user, dependent: :destroy
  has_many :things, dependent: :nullify
  validates :first_name, presence: true
  validates :last_name, presence: true, on: :create # requirement was added later, grandfather in users
  validates_formatting_of :email, using: :email
  validates_formatting_of :sms_number, using: :us_phone, allow_blank: true
  validates_formatting_of :voice_number, using: :us_phone, allow_blank: true
  validates_formatting_of :zip, using: :us_zip, allow_blank: true

  def remove_non_digits_from_phone_numbers
    self.sms_number = sms_number.to_s.gsub(/\D/, '').to_i if sms_number.present?
    self.voice_number = voice_number.to_s.gsub(/\D/, '').to_i if voice_number.present?
  end

  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  # TODO: gracefully reject duplicate emails
  def self.find_for_authentication(conditions = {})
    where(email: conditions[:email], city_domain: CityHelper.city_for_domain(conditions[:host])).first
  end

  # Disable devise email uniqueness check since we require that email + city be unique
  # https://github.com/heartcombo/devise/wiki/How-To%3A-Allow-users-to-sign-in-with-something-other-than-their-email-address
  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
