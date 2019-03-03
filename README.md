# README

Rails API submission for obtaining sequential identifiers. Heroku demo available at https://thinkific-demo.herokuapp.com

Identifiers are integers, and each request returns the next integer in the sequence.

Identifiers start from *0* by default, as common with most programming languages.

However, in the real world, where identifiers are sometimes used as primary keys for resources, you might want to start from 1.

Accessing identifier actions requires creating a user account, thus the first request should ideally be the one that creates the user account, and as mentioned, accounts are created with a default identifier of zero.

However, to start from 1 or any other value instead, you can pass in the additional value to the endpoint while creating the user resource

## Identifier Endpoints
Endpoints are also available to either set the identifier's value, get the current identifier, or increment the identifier by one.

Endpoints that interact with the value of the identifier (setting, reading or incrementing) require authentication.

To authenticate, pass the API token obtained while creating the user as a bearer token in the `Authorization` header. For example:

            Authorization: Bearer <sample-token>

Identifier actions are thread-safe, so you can be assured that multiple requests made to increment/set the identifier are bulletproof from race conditions.

All endpoints require requests that confirm to the JSON api specification described here: https://jsonapi.org. Thus, you have to pass along the Content-Type header for every request as well:

        Content-Type: application/vnd.api+json

## API Actions
### Creating a User

The API endpoint for creating users requires two attributes, and an optional attribute.

Accessible as a `POST` request to https://thinkific-demo.herokuapp.com/api/v1/users

with header:

        Content-Type: application/vnd.api+json

The required attributes are the preferred email and password, while the optional attribute is the initial identifier.

A sample request to create users could be:
```json
{
    "data": {
        "attributes": {
            "email": "test-email@mailinator.com",
            "password": "test-password",
            "identifier": -520
        }
    }
}
```

A sample response is:

```json
{
    "data": {
        "type": "users",
        "attributes": {
            "identifier": -520,
            "api_token": "28slkjdfa2fajsdf9023kdk"
        }
    }
}
```

### Getting current value of identifier

Requires token authentication. 

Available as a `GET` request to https://thinkific-demo.herokuapp.com/api/v1/users/current

with headers:

        Authorization: Bearer 28slkjdfa2fajsdf9023kdk
        Content-Type: application/vnd.api+json

A sample response is:

```json
{
    "data": {
        "type": "users",
        "attributes": {
            "identifier": -520
        }
    }
}
```

### Getting next value of identifier

Requires token authentication. 

Available as a `GET` request to https://thinkific-demo.herokuapp.com/api/v1/users/next

with headers:
    
        Authorization: Bearer 28slkjdfa2fajsdf9023kdk
        Content-Type: application/vnd.api+json

A sample response is:

```json
{
    "data": {
        "type": "users",
        "attributes": {
            "identifier": -519
        }
    }
}
```

### Setting value of identifier

Requires token authentication. 

Available as a `PUT` request to https://thinkific-demo.herokuapp.com/api/v1/users

with headers:
    
        Authorization: Bearer 28slkjdfa2fajsdf9023kdk
        Content-Type: application/vnd.api+json

The only required attribute is the new identifier

A sample request to set the identifier could be:
```json
{
    "data": {
        "attributes": {
            "identifier": 600420
        }
    }
}
```

A sample response is:

```json
{
    "data": {
        "type": "users",
        "attributes": {
            "identifier": 600420
        }
    }
}
```

## Running Locally

Clone the repository, and then run `bundle` to install gem dependencies.

Set up the database by running `rails db:setup` and then,

Start the Rails server, and make a request to any of the endpoints documented.

## Further Actions

Initialized the project with the intention of also adding a React front-end to consume the API.

If I find time sometime this weekend to add that in, I'd get to it as well. However, this is enough of an MVP to fulfill the project's requirements.