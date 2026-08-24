admin = User.create!(
  email: "admin@example.com",
  password: "password",
  role: "admin"
)

seller = User.create!(
  email: "seller@example.com",
  password: "password",
  role: "seller"
)

categories = Category.create!([
  { name: "Electronics", description: "Gadgets and devices" },
  { name: "Clothing", description: "Fashion and apparel" },
  { name: "Books", description: "Physical and digital books" },
  { name: "Home", description: "Home and garden" }
])

Product.create!([
  { name: "Wireless Headphones", description: "Premium noise-cancelling headphones with 30-hour battery life.", price: 199.99, stock: 50, category: categories[0], user: seller },
  { name: "Smart Watch", description: "Fitness tracker with heart rate monitor and GPS.", price: 299.99, stock: 30, category: categories[0], user: seller },
  { name: "Cotton T-Shirt", description: "Comfortable organic cotton t-shirt in various colors.", price: 29.99, stock: 100, category: categories[1], user: seller },
  { name: "Denim Jacket", description: "Classic denim jacket with modern fit.", price: 89.99, stock: 25, category: categories[1], user: seller },
  { name: "Ruby on Rails Tutorial", description: "Learn web development with Rails.", price: 39.99, stock: 200, category: categories[2], user: seller },
  { name: "Plant Pot Set", description: "Set of 3 ceramic plant pots.", price: 49.99, stock: 40, category: categories[3], user: seller }
])

puts "Seeded admin (admin@example.com), seller (seller@example.com), #{Category.count} categories, #{Product.count} products"
