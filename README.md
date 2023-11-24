# Tea Subscription Service

## About this API
This api allows customers to subscribe to a tea subscription, cancel a tea subscription, and view all of their subscriptions, both active and cancelled.

## Table of Contents
- [About this API](#about-this-api)
- [Database Setup and Relationships](#database-setup-and-relationships)
- [Endpoints](#endpoints)
   - [Subscribe a Customer to a Tea Subscription](#subscribe-a-customer-to-a-tea-subscription)
   - [Cancel a Customer's Tea Subscription](#cancel-a-customers-tea-subscription)
   - [See all of a Customer's Subscriptions](#see-all-of-a-customers-subscriptions)

## Database Setup and Relationships
![Schema Setup, includes customers, subscription_customers, subscriptions, tea_subscrptions, and teas](<schema.png>)

**Make sure to do rails db:{drop,create,migrate,seed} before use!**

## Endpoints

### Subscribe a Customer to a Tea Subscription
Request:
```
POST /api/v1/customers/:customer_id/subscriptions/:subscription_id
```
   - `:customer_id` and `:subscription_id` will change based off of the customer being subscribed and the subscription being subscribed to, as these are the ids of those data entries

Regular Response:
```
{
  "success": "Customer has been successfully subscribed."
}
```

Error Response:
```
{

  "error": "Customer was not able to be subscribed. Please make sure the customer or subscription id is correct."
}
```

### Cancel a Customer's Tea Subscription
Request:
```
PATCH /api/v1/customers/:customer_id/subscriptions/:subscription_id
```
 - `:customer_id` and `:subscription_id` will change based off of the customer being subscribed and the subscription being subscribed to, as these are the ids of those data entries

Regular Response:
```
{
  "success": "Customer has been successfully unsubscribed."
}
```

Error Response:
```
{
  "error": "Customer was not able to be unsubscribed. Please make sure the customer or subscription id is correct."
}
```

### See all of a Customer's Subscriptions
Request:
```
GET /api/v1/customers/:customer_id/subscriptions
```
   - `:customer_id` will change based off of the customer being searched, as this is the id of that customer

Regular Response:
```
{
  "data": [
    {
      "id": "1",
      "type": "subscription",
      "attributes": {
        "title": "Minty Delight",
        "price": 25.0,
        "frequency": "2 weeks"
      }
    },
    {...}.
    {...}
  ]
}
```

Invalid Customer Response:
```
  {
    "error": "Couldn't find Customer with 'id'=2"
  }
```

Customer has no Subscriptions Response:
```
{
  "data": []
}
```