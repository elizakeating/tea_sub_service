class Api::V1::SubscriptionCustomersController < ApplicationController
  def create
    Subscription.find(params[:subscription_id]).update_column(:status, 1)

    subscribed = SubscriptionCustomer.new(subscription_id: params[:subscription_id], customer_id: params[:customer_id])

    if subscribed.save
      render json: {success: "Customer has been successfully subscribed."}
    end
  end
end