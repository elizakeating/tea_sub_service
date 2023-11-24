require "rails_helper"

RSpec.describe "Subscription Request" do
  before(:each) do
    @customer_1 = Customer.create(
      first_name: "Tim",
      last_name: "Smith",
      email: "timsmith@tea.com",
      address: "1234 South Tea Lane, CO"
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

    @subscription = Subscription.create(
      title: "Minty Delight",
      price: 25.00,
      frequency: "2 weeks"
    )
  end

  it "sends message showing that a customer has subscribed successfully to a tea subscription" do
    post "/api/v1/customers/#{@customer_1.id}/subscriptions/#{@subscription.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to eq({success: "Customer has been successfully subscribed."})

    expect(@customer_1.subscriptions.count).to eq(1)
    expect(@customer_1.subscriptions.first).to be_a(Subscription)
    expect(@customer_1.subscriptions.first.title).to eq("Minty Delight")
    expect(@customer_1.subscriptions.first.price).to eq(25.0)
    expect(@customer_1.subscriptions.first.status).to eq("active")
    expect(@customer_1.subscriptions.first.frequency).to eq("2 weeks")
  end

  it "sends message showing that customer has been sucessfully unsubscribed from a tea subscription" do
    SubscriptionCustomer.create(customer_id: @customer_1.id, subscription_id: @subscription.id)

    patch "/api/v1/customers/#{@customer_1.id}/subscriptions/#{@subscription.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to eq({success: "Customer has been successfully unsubscribed."})

    expect(@customer_1.subscriptions.count).to eq(1)
    expect(@customer_1.subscriptions.first).to be_a(Subscription)
    expect(@customer_1.subscriptions.first.title).to eq("Minty Delight")
    expect(@customer_1.subscriptions.first.price).to eq(25.0)
    expect(@customer_1.subscriptions.first.status).to eq("cancelled")
    expect(@customer_1.subscriptions.first.frequency).to eq("2 weeks")
  end
end