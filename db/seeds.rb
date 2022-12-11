require 'faker'

# shelters
5.times do 
  Shelter.create!(
    name: Faker::Address.community + "Pet Shelter",
    city: Faker::Address.city + "AZ",
    foster_program: Faker::Boolean.boolean(true_ratio: 0.5),
    rank: Faker::Number.number(digits: 1)
  )
end

# pets
50.times do 
  Pet.create!(
    adoptable: Faker::Boolean.boolean(true_ratio: 0.5),
    age: Faker::Number.number(digits: 1),
    breed: Faker::Creature::Dog.breed,
    name: Faker::Creature::Dog.name,
    shelter_id: rand(1..5)
  )
end