class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    @greeting = t("mailer.account_activation.greeting", name: @user.name)

    mail to: @user.email, subject: t("mailer.account_activation.subject")
  end
end
