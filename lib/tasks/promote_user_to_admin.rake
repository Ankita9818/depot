desc 'changing role of user to promote him to be admin'
task :promote_user_to_admin, [:email] => [:environment] do|t, args|
  user = User.find_by_email(args.email)
  user.role = "admin"
  user.save
end
