# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Role::NAME.each do |name|
  Role.where(name: name).first_or_create
end

admin = Admin.first_or_initialize(email: "admin@gmail.com", password: "password", password_confirmation: "password")
admin.add_role :Admin
admin.save!