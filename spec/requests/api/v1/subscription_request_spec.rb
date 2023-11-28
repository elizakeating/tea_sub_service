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
    expect(@customer_1.subscriptions.first.frequency).to eq("2 weeks")
    expect(@customer_1.subscription_customers.first.status).to eq("active")
  end

  it "sends message showing that customer has been sucessfully unsubscribed from a tea subscription" do
    post "/api/v1/customers/#{@customer_1.id}/subscriptions/#{@subscription.id}"

    patch "/api/v1/customers/#{@customer_1.id}/subscriptions/#{@subscription.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to eq({success: "Customer has been successfully unsubscribed."})

    expect(@customer_1.subscriptions.count).to eq(1)
    expect(@customer_1.subscriptions.first).to be_a(Subscription)
    expect(@customer_1.subscriptions.first.title).to eq("Minty Delight")
    expect(@customer_1.subscriptions.first.price).to eq(25.0)
    expect(@customer_1.subscriptions.first.frequency).to eq("2 weeks")
    expect(@customer_1.subscription_customers.first.status).to eq("cancelled")
  end

  it "should return all of a customer's subscriptions, both active and cancelled" do
    post "/api/v1/customers/#{@customer_1.id}/subscriptions/#{@subscription.id}"
    post "/api/v1/customers/#{@customer_1.id}/subscriptions/#{@subscription_2.id}"

    get "/api/v1/customers/#{@customer_1.id}/subscriptions"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to have_key(:data)
    expect(json[:data]).to be_an(Array)
    expect(json[:data].count).to eq(2)

    json[:data].each do |subscription|
      expect(subscription).to have_key(:id)
      expect(subscription[:id]).to be_a(String)

      expect(subscription).to have_key(:type)
      expect(subscription[:type]).to eq("subscription")

      expect(subscription).to have_key(:attributes)
      expect(subscription[:attributes]).to be_a(Hash)

      expect(subscription[:attributes]).to have_key(:title)
      expect(subscription[:attributes][:title]).to be_a(String)

      expect(subscription[:attributes]).to have_key(:price)
      expect(subscription[:attributes][:price]).to be_a(Float)

      expect(subscription[:attributes]).to have_key(:frequency)
      expect(subscription[:attributes][:frequency]).to be_a(String)
    end
  end

  it "should return message if customer not found when looking for subscription" do
    get "/api/v1/customers/45/subscriptions"

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error).to eq({
      error: "Couldn't find Customer with 'id'=45"
    })
  end

  it "sould return error message if customer was not successfully unsubscribed" do
    patch "/api/v1/customers/56/subscriptions/#{@subscription.id}"

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error).to eq({
      error: "Customer was not able to be unsubscribed. Please make sure the customer or subscription id is correct."
    })
  end

  it "should return error if customr was not able to be subscribed" do
    post "/api/v1/customers/#{@customer_1.id}/subscriptions/45"

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error).to eq({
      error: "Customer was not able to be subscribed. Please make sure the customer or subscription id is correct."
    })
  end
end