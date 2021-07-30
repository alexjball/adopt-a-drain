# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Adopt a Drain Medford <enviro@medford-ma.gov>'
  layout 'mailer'
end
