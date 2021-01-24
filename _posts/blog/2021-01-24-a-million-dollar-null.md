---
layout: post
title: A Million Dollar Null
categories: blog
date: 2021-01-24 14:12 +0100
---

Ok, maybe not a million but could've cost a lot of money.

## The Story

Once upon a time, I was tasked with getting some historic data for a key project. I was supposed to get the data from a PostgreSQL database and all the data pivoted around a table similar to the following:

```sql
create table operation (
    operationid bigserial primary key,
    creationdate date not null, -- Deprecated, we should only use the timestamp
    creationtimestamp timestamptz,
    amount bigint, -- The amount in minor units
    additionalthings jsonb,
    operationtypeid bigint references operation_type,
    -- ... more stuff here
)
```

The task was simple, I had to get all the operations that happened in the past six months, hidrate them with some other data sources and send a csv file so we can get paid. Simple enough, right?

The only things I had to keep in mind where those `creationdate` and `creationtimestamp` columns. I knew at some time we stopped paying attention to the `creationdate` and moved to using `creationtimestamp` so I should check if the period I'm interested in overlaps with the period when we were only using the `creationdate` field. 

```sql
> select count(*) from operation 
where creationdate != creationtimestamp::date
  and creationtimestamp >= now() - interval'6 months'

 count 
-------
     0
(1 row)
```

Seems like I'm not affected so I can move on to hidrating the data and finishing my Friday early, right? Easy enough, right? *RIGHT*? That's exactly what I did without noticing that my sanity check was completely meaningless.

See, the `creationtimestamp` columns was nullable because it had been introduced way after the creation of the table (enough time for making it infeasible to backfill), so the comparison I made between it and the `creationdate` makes no sense.  
`NULL` compared with anything is always `NULL`, thus you cannot say that the columns are different or equal, you just cannot compare them in that way. 

Had I done something like the following, I would've noticed that I was missing almost three months of data:

```sql
> select min(creationtimestamp) from operation;

          min           
------------------------
 2020-08-15 00:00:00+02
(1 row)

> select count(*) from operation
 where creationtimestamp is null
   and creationdate > now() - interval '6 months';

 count 
-------
  1800
(1 row)
```

<small>... *Shit.*</small>

## Conclusion

This is just a watered down version of what actually happened, and of course I'm making the query examples on synthetic data but the essence of the mistake I made is still there. Fortunately a second sanity check someone else did before submitting the data was enough to catch it so I could fix it on time. 