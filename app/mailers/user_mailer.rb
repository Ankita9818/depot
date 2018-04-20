class UserMailer < ApplicationMailer

  default from: DEFAULT_SENDER_EMAIL

  def welcome(user)
    @user = user
    mail to: user.email, subject: 'Welcome To Our Store'
  end
end
