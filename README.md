# craigfinder
Script to auto-search Craigslist and email you any hits.

**Release Notes**
1. Probably violates Craigslist terms of service.  I don't use it.  Maybe you shouldn't either.  Consult your lawyer.
2. The mailer portion broke in 2015 when Google tightened security on Gmail.  You can still use it on the command line.

**Directions**
1. Clone this repository.
2. Install Mysql, rubygems and bundler.
3. `mysql -uyourusername -pyourpassword < db_setup.sql` to set up the database.
4. `bundle install` to install the gems you need.
5. Edit detais.yml to contain your database and Gmail usernames and passwords.
6. Edit queries.yml to set search locations, search strings, and result recipients.
7. Run it:  `ruby craig.rb`
8. Add it to your cron file and run it every few minutes to get almost instant notification of new CL posts.
9. Do the last two items only after consulting your lawyer.
