# frozen_string_literal: true

class ThingMailer < ApplicationMailer
  def from_city
    config = CityHelper.config(@current_city)
    "#{config.brand.name} #{config.city.name} <noreply@mysticdrains.org>"
  end

  def adopted
    config = CityHelper.config(@current_city)
    config.brand.adopted
  end

  def adopting
    config = CityHelper.config(@current_city)
    config.brand.adopting
  end

  def first_adoption_confirmation(thing)
    @thing = thing
    @user = thing.user
    @current_city = thing.city_domain

    mail(from: from_city, to: @user.email, subject: ["Thanks for #{adopting} a drain, #{@user.name.split.first}!"])
  end

  def second_adoption_confirmation(thing)
    @thing = thing
    @user = thing.user
    @current_city = thing.city_domain

    mail(from: from_city, to: @user.email, subject: ["Thanks for #{adopting} another drain, #{@user.name.split.first}!"])
  end

  def third_adoption_confirmation(thing)
    @thing = thing
    @user = thing.user
    @current_city = thing.city_domain

    mail(from: from_city, to: @user.email, subject: ["We really do love you, #{@user.name.split.first}!"])
  end

  def reminder(thing)
    @thing = thing
    @user = thing.user
    @current_city = thing.city_domain

    mail(from: from_city, to: @user.email, subject: ["Remember to clear your #{adopted} drain"])
  end

  # rubocop:disable Metrics/AbcSize
  def thing_update_report(deleted_things_with_adoptee, deleted_things_no_adoptee, created_things)
    @deleted_thing_ids_with_adoptee = deleted_things_with_adoptee.map { |t| t['city_id'] }
    @deleted_thing_ids_with_no_adoptee = deleted_things_no_adoptee.map { |t| t['city_id'] }
    @created_thing_ids = created_things.map { |t| t['city_id'] }
    subject = t('subjects.update_report',
                title: t('titles.main', thing: t('defaults.thing').titleize, city: c('city.name')),
                deleted_adopted_count: deleted_things_with_adoptee.count,
                created_count: created_things.count,
                deleted_unadopted_count: deleted_things_no_adoptee.count,
                things: t('defaults.things')
              ) 
    mail(to: User.where(admin: true).pluck(:email), subject: subject)
  end
  # rubocop:enable Metrics/AbcSize
end
