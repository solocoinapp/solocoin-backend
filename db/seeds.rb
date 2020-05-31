# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Admin User creation
User.create(name: 'Admin user', email: 'admin111@admin.com', password: '!QAZ2wsx', password_confirmation:'!QAZ2wsx', role: 1)
