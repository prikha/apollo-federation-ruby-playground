Lazy loading works with a patched version. Try this query: 

```
{
  topReviews {
    body
    product {
      upc
      name
    }
  }
}
```

And inspect the output:

```
products  | {:query=>
products  |   "query ($representations: [_Any!]!) {\n" +
products  |   "  _entities(representations: $representations) {\n" +
products  |   "    ... on Product {\n" +
products  |   "      name\n" +
products  |   "    }\n" +
products  |   "  }\n" +
products  |   "}",
products  |  :operationName=>nil,
products  |  :vars=>
products  |   {"representations"=>
products  |     [{"__typename"=>"Product", "upc"=>"1"},
products  |      {"__typename"=>"Product", "upc"=>"2"},
products  |      {"__typename"=>"Product", "upc"=>"3"},
products  |      {"__typename"=>"Product", "upc"=>"1"},
products  |      {"__typename"=>"Product", "upc"=>"1"}]},
products  |  :schema=>ProductSchema}
products  | >>>> Products repo called
products  | 127.0.0.1 - - [11/Oct/2019:12:57:36 MSK] "POST /graphql HTTP/1.1" 200 109
products  | - -> /graphql
```

Notice the product repo called once instead of N as it has been before.