# frozen_string_literal: true

require_relative './graphql_server'

# type Review @key(fields: "id") {
#   id: ID!
#   body: String
#   author: User @provides(fields: "username")
#   product: Product
# }

# extend type User @key(fields: "id") {
#   id: ID! @external
#   username: String @external
#   reviews: [Review]
# }

# extend type Product @key(fields: "upc") {
#   upc: String! @external
#   reviews: [Review]
# }

REVIEWS = [
  {
    id: '1',
    authorID: '1',
    product: { upc: '1' },
    body: 'Love it!',
  },
  {
    id: '2',
    authorID: '1',
    product: { upc: '2' },
    body: 'Too expensive.',
  },
  {
    id: '3',
    authorID: '2',
    product: { upc: '3' },
    body: 'Could be better.',
  },
  {
    id: '4',
    authorID: '2',
    product: { upc: '1' },
    body: 'Prefer something else.',
  },
  {
    id: '4',
    authorID: '3',
    product: { upc: '1' },
    body: 'Dummy',
  },
  {
    id: '4',
    authorID: '4',
    product: { upc: '1' },
    body: 'Dummy',
  },
  {
    id: '4',
    authorID: '5',
    product: { upc: '1' },
    body: 'Dummy',
  },
  {
    id: '4',
    authorID: '6',
    product: { upc: '1' },
    body: 'Dummy',
  },
  {
    id: '4',
    authorID: '7',
    product: { upc: '1' },
    body: 'Dummy',
  },
  {
    id: '4',
    authorID: '8',
    product: { upc: '1' },
    body: 'Dummy',
  },
  {
    id: '4',
    authorID: '9',
    product: { upc: '1' },
    body: 'Dummy',
  },
].freeze

class Review < BaseObject
  key fields: 'id'

  field :id, ID, null: false
  field :body, String, null: true
  field :author, 'User', null: true
  field :product, 'Product', null: true

  def author
    { __typename: 'User', id: object[:authorID] }
  end
end

class User < BaseObject
  key fields: 'id'
  extend_type

  field :id, ID, null: false, external: true
  field :reviews, [Review], null: true

  def reviews
    REVIEWS.select { |review| review[:authorID] == object[:id] }
  end
end

class Product < BaseObject
  key fields: 'upc'
  extend_type

  field :upc, String, null: false, external: true
  field :reviews, [Review], null: true

  def reviews
    REVIEWS.select { |review| review[:product][:upc] == object[:upc] }
  end
end

class Query < BaseObject
  field :top_reviews, [Review], null: false do
    argument :first, Int, required: false, default_value: 5
  end

  def top_reviews(first:)
    REVIEWS.slice(0, first)
  end
end

class ReviewSchema < GraphQL::Schema
  include ApolloFederation::Schema

  orphan_types User, Review, Product
  
  query(Query)
end

GraphQLServer.run(ReviewSchema, Port: 5002)
