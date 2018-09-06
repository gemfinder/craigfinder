#!/usr/bin/env ruby

# Bill Mitchell, July 24, 2005
#      Kudos to Jeremy Zawodny for a Perl script that suggested this idea.
#      See http://jeremy.zawodny.com/blog/archives/001440.html
#
#      This script may violate the Craigslist terms of service.
#      Read the TOS, or ask them, before using this.


require 'yaml'
require 'rexml/document'
require 'open-uri'
require 'mysql2'
require_relative 'gmailer'

details = YAML::load(File.open "details.yml") # load details for access to database and email

# connect to database
my = Mysql2::Client.new(:host => 'localhost', :username => details["db_user"], :password => details["db_password"])
my.select_db('craigslist')

config = YAML::load(File.open "queries.yml")

config["users"].each do
    |user|
    result = ''
    user["queries"].each do 
        |query|
        config["regions"].each do
            |region|
            feedurl = "http://" + region + ".craigslist.org/search/sss?query=" + query + "&srchType=A&format=rss"
            #puts feedurl
        
            xml = REXML::Document.new(open(feedurl).read)
            xml.elements.each("//item") do
                |item|
                begin
                    link = item.elements["link"].text
                    title = item.elements["title"].text

                    listing_id = File.basename(link, ".txt").to_i
                    
                    my.query("insert into listings (link, date, listing_id) values ('#{link}', curdate(), #{listing_id})")
                    result << "#{title}\n#{link}\n\n"
                rescue Mysql2::Error
                    puts "Ignoring duplicate entry:", title, link, listing_id, ""
                end
            end
        end
    end
    puts "Wanted to send to #{user['email']}: #{result}"
    Gmailer::send(details[mail_user], details[mail_password], user["email"], "Craigslist results", result) if result != ''
end

my.close
