class UserMailer < ApplicationMailer

  default from: 'ankitadixit.rails@gmail.com'

  def welcome(user)
    @user = user
    @greeting = 'Helllo !!!'
    mail to: user.email, subject: 'Welcome To Our Store'
  end
end
