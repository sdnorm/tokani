User.create!(name: "Super Admin", email: "super@admin.com", password: "password", password_confirmation: "password", admin: true, terms_of_service: true)

AccountUser.create!(account_id: Account.find_by(name: "Super Admin").id, user_id: User.find_by(email: "super@admin.com").id, roles: {"admin" => true})
