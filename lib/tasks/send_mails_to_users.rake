desc 'sending emails to all the users about their orders'
task send_mails_to_users: :environment do
  User.all.each do |user|
    UserMailer.consolidate_mail(user).deliver_now
  end
end
