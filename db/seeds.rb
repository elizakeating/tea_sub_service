# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

@customer_1 = Customer.create(
  first_name: "Tim",
  last_name: "Smith",
  email: "timsmith@tea.com",
  address: "1234 South Tea Lane, CO"
)

@customer_2 = Customer.create(
  first_name: "Lacy",
  last_name: "Adams",
  email: "lacyadams@gmail.com",
  address: "4591 South Leaf Lane, CO"
)

@tea_1 = Tea.create(
  title: "Peppermint",
  description: "Minty goodness",
  temperature: "110 F",
  brew_time: "5 minutes"
)

@tea_2 = Tea.create(
  title: "Spearmint",
  description: "Crisp minty goodness",
  temperature: "115 F",
  brew_time: "4 minutes"
)

@tea_3 = Tea.create(
  title: "Blueberry",
  description: "Blueberry goodness",
  temperature: "100 F",
  brew_time: "6 minutes"
)

@tea_4 = Tea.create(
  title: "Raspberry",
  description: "Raspberry goodness",
  temperature: "105 F",
  brew_time: "3 minutes"
)

@subscription = Subscription.create(
  title: "Minty Delight",
  price: 25.00,
  frequency: "2 weeks"
)

@subscription_2 = Subscription.create(
  title: "Fruity Fun",
  price: 45.00,
  frequency: "1 month"
)

TeaSubscription.create(subscription_id: @subscription.id, tea_id: @tea_1.id)
TeaSubscription.create(subscription_id: @subscription.id, tea_id: @tea_2.id)

TeaSubscription.create(subscription_id: @subscription_2.id, tea_id: @tea_3.id)
TeaSubscription.create(subscription_id: @subscription_2.id, tea_id: @tea_4.id)