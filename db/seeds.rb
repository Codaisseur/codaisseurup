Photo.delete_all
Category.delete_all
Event.delete_all
Profile.delete_all
User.delete_all

miriam = User.create!(
  email: "miriam@codaisseurup.com",
  password: "abcd1234",
)

photo1 = Photo.create(remote_image_url: "http://res.cloudinary.com/dnwkjak4p/image/upload/v1489331995/yoga_dog_03_iy1ukm.jpg")
photo2 = Photo.create(remote_image_url: "http://res.cloudinary.com/dnwkjak4p/image/upload/v1489331985/yoga_dog_02_affayd.jpg")
photo3 = Photo.create(remote_image_url: "http://res.cloudinary.com/dnwkjak4p/image/upload/v1489331989/yoga_dog_01_swh1ea.jpg")

event = Event.create!(
  name: "Monthly Yoga Weekend",
  description: "Let's come together and practice some asanas together in the woods!",
  location: "Amsterdam",
  includes_food: false,
  includes_drinks: true,
  price: 10.00,
  starts_at: 10.days.from_now,
  ends_at: 12.days.from_now,
  capacity: 100,
  active: true,
  user: miriam,
  photos: [photo1, photo2, photo3],
)

Category.create!([
  { name: "Movements" },
  { name: "Outdoors & Adventure" },
  { name: "Tech" },
  { name: "Family" },
  { name: "Health & Wellness" },
  { name: "Sports & Fitness" },
  { name: "Learning" },
  { name: "Photography" },
  { name: "Food & Drink" },
])

event = Event.find_by(name: "Monthly Yoga Weekend")
event.categories << Category.find_by(name: "Outdoors & Adventure")
event.categories << Category.find_by(name: "Sports & Fitness")
