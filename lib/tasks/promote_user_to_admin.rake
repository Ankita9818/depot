desc 'changing role of user to promote him to be admin'
task :promote_user_to_admin, [:email] => [:environment] do|t, args|
  begin
    user = User.find_by(email: args.email)
      user.role = ADMIN
      user.save!
  rescue StandardError => e
    p e.message
  end
end
