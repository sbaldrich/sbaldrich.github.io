---
layout: post
title: PSQL Goodies
date: 2021-03-01 19:46 +0100
categories: blog
---

I spend quite some time using `psql` during my day, and over time I've found some nice things that make my workflow better:


### Variables 

You can set variables using `\set`, this is helpful in cases when you need to run the same query over and over again (for example, during some exploratory analysis) with different input parameters.


```sql
\set question '''The answer to life, the universe and everything'''
\set answer 42

select :question as question, :answer as answer from generate_series(1,5);

select :question as question, :answer as answer from generate_series(
                    question                     | answer 
-------------------------------------------------+--------
 The answer to life, the universe and everything |     42
 The answer to life, the universe and everything |     42
 The answer to life, the universe and everything |     42
 The answer to life, the universe and everything |     42
 The answer to life, the universe and everything |     42
(5 rows)
```

You can also store the result of a query in a variable using `\gset`:

```sql
select 42 as answer \gset
\echo The answer to life, the universe and everything is :answer.
The answer to life, the universe and everything is 42.
```

Use `\unset` to delete a variable.

### Formatting

You probably know that `\x` enables the expanded display mode:

```sql
\x
Expanded display is on.
select md5(random()::varchar || current_timestamp::varchar)::uuid uid,
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
     tempor incididunt ut labore et dolore magna aliqua.
      Ut enim ad minim veniam...' lorem;
[ RECORD 1 ]-------------------------------------------------------------------------------------------------------------------------------------------------
uid   | 4be8d427-c0f5-448a-1686-b91bd4f61667
lorem | Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam...
```

But using `\pset format wrapped` you can keep the column mode and have a "nicely" formatted output:

```sql
\pset format wrapped
\pset columns 80
select md5(random()::varchar || current_timestamp::varchar)::uuid uid,
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
     tempor incididunt ut labore et dolore magna aliqua.
      Ut enim ad minim veniam...' lorem;
                 uid                  |                  lorem                  
--------------------------------------+-----------------------------------------
 de21cb74-e79f-b9d4-ff70-8e0b04a0e0b2 | Lorem ipsum dolor sit amet, consectetur.
                                      |. adipiscing elit, sed do eiusmod tempor.
                                      |. incididunt ut labore et dolore magna a.
                                      |.liqua. Ut enim ad minim veniam...
(1 row)
```

### Making Your Life Easier

Execute a query every `n` seconds using `\watch`:

```sql
# select random() \watch 1
mon 01 mar 2021 20:50:13 CET (every 1s)

      random       
-------------------
 0.592619172297418
(1 row)

mon 01 mar 2021 20:50:14 CET (every 1s)

      random       
-------------------
 0.760892618447542
(1 row)

mon 01 mar 2021 20:50:15 CET (every 1s)

      random       
-------------------
 0.498985073994845
(1 row)

mon 01 mar 2021 20:50:16 CET (every 1s)

      random       
-------------------
 0.157784981653094
(1 row)

mon 01 mar 2021 20:50:17 CET (every 1s)

      random       
-------------------
 0.850564768537879
(1 row)
```

You could write anonymous functions to do things like creating or truncating multiple tables at once: 

```sql
DO
$$
BEGIN
FOR c in 65..70 loop
 EXECUTE 'CREATE TABLE sample.'|| chr(c) || '()';
END loop;
END$$;

DO
```

```sql
DO
$$
BEGIN
   EXECUTE
	(SELECT 'TRUNCATE TABLE ' || string_agg(table_schema || '.' || 
    table_name, ', ') || ' RESTART IDENTITY CASCADE'
		FROM information_schema.tables 
		WHERE table_schema in ('sample')
		);
END$$;

DO
```

Or, you could use `\gexec` to execute the results of the query:

```sql
select 'CREATE TABLE sample.' || chr(generate_series(65, 70)) || '()' \gexec

CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
CREATE TABLE
```

```sql
SELECT 'TRUNCATE TABLE ' || string_agg(table_schema || '.' || 
    table_name, ', ') || ' RESTART IDENTITY CASCADE'
		FROM information_schema.tables 
		WHERE table_schema in ('sample') \gexec

TRUNCATE TABLE
```

### Conclusion

There are quite some useful things that can be found using the help (`\?`) command in `psql`, it's not the worst idea to go give it a look.
