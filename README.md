# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


# Seed de Usuarios 

* 10.times do 
    User.create(firstName:Faker::Name.first_name,lastName:Faker::Name.last_name ,email:Faker::Internet.email,password:"12345",photo:"perfil.jpg",role_id:1)
end
* 10.times do 
    User.create(firstName:Faker::Name.first_name,lastName:Faker::Name.last_name ,email:Faker::Internet.email,password:"12345",photo:"perfil.jpg",role_id:2)
end

# Link Postman
* https://www.getpostman.com/collections/368a47e5652e65554e92