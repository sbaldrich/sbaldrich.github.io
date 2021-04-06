---
layout: post
title: Sharding with Shredder
date: 2021-04-06 17:46 +0200
categories: blog
---

There's a pretty [popular article](https://instagram-engineering.com/sharding-ids-at-instagram-1cf5a71e5a5c) that describes a technique used by Instagram to generate unique ids in their sharded infrastructure. I guess this is not the case anymore, but it is an interesting solution to an interesting problem. In a nutshell, they create _logical shards_ (PostgreSQL schemas) with tables that have the responsibility of generating snowflake ids upon insertion.

The method has the following advantages: 

* The server id is embedded in the id, so you can pinpoint the location of whatever you're looking for without a lookup table.
* Id's are sortable by time because the creation (custom) epoch is embedded in the id.
* There's no SPOF in the id generation flow because database servers are not coupled with each other.

The advantage of using schemas is that theoretically (I didn't try this out) you can easily migrate the data from a schema to a new database cluster if it becomes too large without having to change too much of your routing logic.

Since they made it look so easy, I decided to create **Shredder**, a very simple sharding POC to put this to the test.

I simulated three database servers using containers. Each one uses multiple schemas, so the described method can be applied on each of them. 
<script src="https://gist.github.com/sbaldrich/d5d906adfdddc62911cd5dbb257c6180.js"></script>

The database setup script is in charge of creating the schemas and id generation functions. Notice how I ensure that every shard has an unique id, this is critical for maintaining the first property described above (otherwise we wouldn't be able to track where some user's data is stored at).

<script src="https://gist.github.com/sbaldrich/f02f49e29e72f1178ed44b526282bae4.js"></script>

To see it working, I created a simple test that uses 10 threads that create 100 users each. After checking that all users were (apparently) stored, it verifies that each one can be found in the expected location.

<script src="https://gist.github.com/sbaldrich/d346203cac4e25a22517983938d20e30.js"></script>

The last interesting part of the code is the `DataManager` implementation. It keeps the connections to all databases and is in charge of returning the correct one depending on the received shard key.

<script src="https://gist.github.com/sbaldrich/ac4eb9cb40681c099c0adfb9953ba470.js"></script>

The full code is available [here](https://github.com/sbaldrich/zoo/tree/master/shredder).

### Conclusion

* Handling the routing on the application layer is not trivial.
* Care has to be taken when assigning shard ids, I defined an environment variable `SCHEMA_BASE_ID` to handle it but this is definitely a brittle approach.
* Ideally, client connections shouldn't have to deal with lower level details of the connection such as setting the schema to use. Plus with this method we're effectively removing the posibility to use schemas for other purposes.

<small>Is this usef... you know the drill.<small/>




