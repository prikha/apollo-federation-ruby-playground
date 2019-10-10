# frozen_string_literal: true

require_relative './graphql_server'
require 'date'

# extend type Query {
#   me: User
# }

# type User @key(fields: "id") {
#   id: ID!
#   name: String
#   username: String
# }

USERS = [
  {
  "id": 1,
  "name": "Isaiah Lake",
  "birthDate": "1988-07-11",
  "username": "ilake0"
}, {
  "id": 2,
  "name": "Moore Le Houx",
  "birthDate": "1975-02-03",
  "username": "mle1"
}, {
  "id": 3,
  "name": "Jermaine Mellem",
  "birthDate": "1967-07-15",
  "username": "jmellem2"
}, {
  "id": 4,
  "name": "Zebulon Stronge",
  "birthDate": "1995-05-21",
  "username": "zstronge3"
}, {
  "id": 5,
  "name": "Sosanna Emmison",
  "birthDate": "1995-03-09",
  "username": "semmison4"
}, {
  "id": 6,
  "name": "Korey Balke",
  "birthDate": "2000-12-07",
  "username": "kbalke5"
}, {
  "id": 7,
  "name": "Julietta Gorler",
  "birthDate": "1978-01-22",
  "username": "jgorler6"
}, {
  "id": 8,
  "name": "Efrem Breeds",
  "birthDate": "1999-02-28",
  "username": "ebreeds7"
}, {
  "id": 9,
  "name": "Emeline Livsey",
  "birthDate": "1997-08-28",
  "username": "elivsey8"
}, {
  "id": 10,
  "name": "Tedmund Collinson",
  "birthDate": "1968-05-28",
  "username": "tcollinson9"
}, {
  "id": 11,
  "name": "Eydie Hargey",
  "birthDate": "1999-01-15",
  "username": "ehargeya"
}, {
  "id": 12,
  "name": "Daniel Kiffin",
  "birthDate": "1971-11-19",
  "username": "dkiffinb"
}, {
  "id": 13,
  "name": "Clarence Jupp",
  "birthDate": "1991-09-01",
  "username": "cjuppc"
}, {
  "id": 14,
  "name": "Hedvig Chopy",
  "birthDate": "2002-12-08",
  "username": "hchopyd"
}, {
  "id": 15,
  "name": "Salem Grumell",
  "birthDate": "1999-08-14",
  "username": "sgrumelle"
}, {
  "id": 16,
  "name": "Bendicty Desmond",
  "birthDate": "1983-11-19",
  "username": "bdesmondf"
}, {
  "id": 17,
  "name": "Marcus Brito",
  "birthDate": "1982-09-05",
  "username": "mbritog"
}, {
  "id": 18,
  "name": "Riane Goldin",
  "birthDate": "1969-08-10",
  "username": "rgoldinh"
}, {
  "id": 19,
  "name": "Pall Archbutt",
  "birthDate": "1972-03-11",
  "username": "parchbutti"
}, {
  "id": 20,
  "name": "Renell Branscomb",
  "birthDate": "1995-11-19",
  "username": "rbranscombj"
}, {
  "id": 21,
  "name": "Enrique Righy",
  "birthDate": "1970-12-02",
  "username": "erighyk"
}, {
  "id": 22,
  "name": "Conchita McBrearty",
  "birthDate": "1989-07-22",
  "username": "cmcbreartyl"
}, {
  "id": 23,
  "name": "Rollin Simoes",
  "birthDate": "1986-12-30",
  "username": "rsimoesm"
}, {
  "id": 24,
  "name": "Pierrette Eisig",
  "birthDate": "1991-06-09",
  "username": "peisign"
}, {
  "id": 25,
  "name": "Catrina O'Loughnan",
  "birthDate": "1991-06-16",
  "username": "coloughnano"
}
].freeze

class User < BaseObject
  key fields: 'id'

  field :id, ID, null: false
  field :name, String, null: true
  field :username, String, null: true

  def self.resolve_reference(reference, _context)
    puts "[N+1] #{name}: resolving #{reference}"
    USERS.find { |user| user[:id].to_s == reference[:id].to_s }
  end
end

class Query < BaseObject
  field :me, User, null: true

  field :listAccounts, [User], null: false do
    argument :first, Int, required: false, default_value: 5
  end

  def list_accounts(first:)
    USERS.slice(0, first)
  end

  def me
    USERS[0]
  end
end

class AccountSchema < GraphQL::Schema
  include ApolloFederation::Schema

  query(Query)
end

GraphQLServer.run(AccountSchema, Port: 5001)
