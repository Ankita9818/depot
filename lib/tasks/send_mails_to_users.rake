desc 'sending emails to all the users about their orders'
task send_mails_to_users: :environment do
  User.all.each do |user|
    user.send_orders_info_email
  end
end
