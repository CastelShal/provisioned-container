# provisioned-container
user = User.where(id: 1).first
user.password = 'password'
user.password_confirmation = 'password'
user.save
exit