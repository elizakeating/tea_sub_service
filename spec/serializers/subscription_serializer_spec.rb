require "rails_helper"

RSpec.describe SubscriptionSerializer do
  it "should return a serialized subscription" do
    subscription = Subscription.create(
      title: "Fruity Fun",
      price: 45.00,
      frequency: "1 month"
    )

    serialized_data = SubscriptionSerializer.new(subscription).serializable_hash

    expect(serialized_data).to eq({
      data: {
        id: subscription.id.to_s,
        type: :subscription,
        attributes: {
          title: subscription.title,
          price: subscription.price,
          frequency: subscription.frequency
        }
      }
    })
  end
end