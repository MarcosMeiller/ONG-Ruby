# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Activity.create(name: "Soloridad", content: "Adhesión o apoyo incondicional a causas o intereses ajenos, especialmente en situaciones comprometidas o difíciles", image: "url.png")
Activity.create(name: "Cooperacion", content: "un grupo de vecinos se reúne para pintar de color azul los frentes de algunas casas para mejorar el aspecto del barrio", image: "url.png")
Activity.create(name: "Voluntariado", content: "llevar a cabo su trabajo en los lugares en que van a ofrecer su ayuda", image: "url.png")
Activity.create(name: "Garantizar los derechos de la infancia", content: "aportando a sus familias todos los medios suficientes para el autodesarrollo de sus capacidades, con el fin de que aspiren a una vida digna", image: "url.png")
Activity.create(name: "Donativo", content: "En caso de llevar alimentos, hay que disponer de los medios móviles disponibles o alquilar nuevos que lleven la ayuda humanitaria donde se necesita", image: "url.png")
Activity.create(name: "Alimentar", content: "Alimentar, enseñar, fortalecer y apoyar a las familias de menos recursos, promoviendo la reintegración de su dignidad", image: "url.png")


10.times do 
    User.create(firstName:Faker::Name.first_name,lastName:Faker::Name.last_name ,email:Faker::Internet.email,password:"12345",photo:"perfil.jpg",role_id:1)
end
10.times do 
    User.create(firstName:Faker::Name.first_name,lastName:Faker::Name.last_name ,email:Faker::Internet.email,password:"12345",photo:"perfil.jpg",role_id:2)
end