Geonames-Rails
===

I need a decent plugin that can do the following things

  * generate a standard db migration
  * pull down the required geonames files from the web
  * load those geonames files in the db (assuming a schema from the migration)
  * generate me my models for free (but leave them in models so i can hack them up later)

DONE
---

  * generators for the db migration & models
  * rake task that will pull the latest geonames data into tmp

TODO
---
  * actually put something in the db migrations
  * write the text -> AR converter