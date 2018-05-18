class UserMailer < ApplicationMailer

  default from: DEFAULT_SENDER_EMAIL

  def welcome(user)
    @user = user
    mail to: user.email, subject: 'Welcome To Our Store'
  end

  def consolidate_mail(user)
    @user = user
    I18n.with_locale(user.language) do
      mail to: user.email, subject: t('.subject')
    end
  end
end
