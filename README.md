# README

Rails API submission for obtaining sequential identifiers. Heroku demo available at https://thinkific-demo.herokuapp.com

Identifiers are integers, and each request returns the next integer in the sequence. Identifiers start from *0* by default, as common with most programming languages. However, in the real world, where identifiers are sometimes used as primary keys for resources, you might want to start from 1.

Accessing identifier actions requires creating a user account, thus the first request should ideally be the one that creates the user account, and as mentioned, accounts are created with a default identifier of zero. However, to start from 1 or any other value instead, you can pass in the additional value to the endpoint while creating the user resource

Endpoints are also available to either set the identifier's value, get the current identifier, or increment the identifier by one.

Endpoints that interact with the value of the identifier (setting, reading or incrementing) require authentication. To authenticate, pass the API token obtained while creating the user as a URL parameter to the endpoint, with the param `api_token`

Identifier actions are thread-safe, so you can be assured that multiple requests made to increment/set the identifier are bulletproof from race conditions.

All endpoints require requests that confirm to the JSON api specification described here: https://jsonapi.org.
TLDR: Pass `application/vnd.api+json` as the value for the `Content-Type` header, and match sample JSON body shared below.

API Actions
===============
* Creating a User

The API endpoint for creating users requires two attributes, and an optional attribute.
The required attributes are the preferred email and password, while the optional attribute is the initial identifier.

A sample request to create users could be:
```json
{
    "data": {
        "type": "users",
        "attributes": {
            "identifier": 5546
        }
    }
}
```

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
