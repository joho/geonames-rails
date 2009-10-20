Geonames-Rails
===

I need a decent plugin that can do the following things with [the geonames database](http://www.geonames.org/)

  * generate a standard db migration
  * pull down the required geonames files from the web
  * load those geonames files in the db (assuming a schema from the migration)
  * generate me my models for free (but leave them in models so i can hack them up later)

Install the plugin by doing the following in your rails app root dir
<pre>
	script/plugin install git://github.com/joho/geonames-rails.git
</pre>

You next step is to run the generators to give you the bare bones country/city models and the db migration
<pre>
	script/generate geonames_migration
	script/generate geonames_models
</pre>

Once you've run that migration and got your models set up how you like you're right to pull down the data straight from the geonames server and into your database. It's as easy as one little command
<pre>
	rake geonames_rails:pull_and_load_data
</pre>

DONE
---

  * generators for the db migration & models
  * rake task that will pull the latest geonames data into tmp
  * actually put something in the db migrations
	* write the text -> AR converter

TODO
---

  * allow you to declare which fields you're using from geonames (and have the mapper do it magically for you)
  * add regions? (maybe, i'm not sure they're worth it)

---

Copyright John Barton 2009