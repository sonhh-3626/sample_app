class ApplicationMailer < ActionMailer::Base
  default from: Settings.server_email
  layout "mailer"
end
