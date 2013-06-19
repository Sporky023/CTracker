CurrencyTracker
===============

CurrencyTracker allows you to track your personal collection of world currencies, by tagging the countries that you've visited along your travels.

Features
--------

* Track Visited Countries
* Track Collected Currencies
* Charts show you how far along you are!

Instructions
============

To showcase your Ruby on Rails skills, please perform this exercise and submit your results. You should use Rails 3 and any gems you find useful. Please spend no more than six consecutive hours.
The starting application is a scaffolded Rails application that satisfies the stories below. It was developed under Ruby Enterprise Edition 1.8.7-2010.01 using RVM and bundler. The project tree also contains a Git repository with the project checked into it. We have implemented several tests and features that validate the current behavior.
For evaluation, please submit an archive of your project results. Include a readme file explaining your assumptions, providing any necessary assumptions, and stating what you would accomplish with more time. Submission evaluation will focus more upon functionality and less upon styling design. Evaluation will include automated testing and review of the submissions design, programming, and testing.
Thank you for committing this time and effort—we are looking forward to seeing your results.

Existing Application
====================

Mr. Smart is a private money collector. He wakes up one morning inspired with the idea of creating the only complete private currency collection in the world. To do this, he must first be able to identify all of the available currencies, and then identify where in the world the currencies are located. His plan is to pick a single currency and then visit the issuing country to acquire bills and coins in various denominations.
Mr Smart has already hired a developer who has developed a proof of concept. This application allows Mr. Smart to privately track his own currency collection. The application was developed to the following stories.
Identifying Unvisited Countries
Mr. Smart wants to identify his next currency to collect. Being a traveller, Mr. Smart prefers to choose his next trip by country. He checks a country list that indicates which ones he has visited. He chooses one that he has not visited and makes his travel plans.

Identifying the Issuing Country
-------------------------------

Having decided to collect a particular currency, Mr. Smart must travel to collect it. Mr. Smart views information on the currency. Among the information offered is its issuing country. Mr. Smart notes the currency’s issuing country and makes travel plans.

Tracking the Collection
-----------------------

Once Mr. Smart has visited a country and collected a currency, he must record this update so that he knows he does not need to repeat it. Mr. Smart indicates the
visitation and collection for future reference. Mr. Smart never visits countries without collecting currency. He also never collects without visiting the issuing country. Mr. Smart prefers graphical indication of his collection’s progress.

Identifying Available Currencies
--------------------------------

Occasionally, Mr. Smart wants a particular currency that he does not already have in his collection. He views a list of available currencies. For each currency, the list indicates whether or not Mr. Smart already has it in his collection. Using this information, he chooses his next currency to acquire.

Enhancements
============

Mr. Smart has since been wildly successful with his collecting. In the process, he has realized that there are many others like him looking for such an application. To this purpose, he has brought you in to enhance it. Please implement the following stories.

Multi-tenant app
----------------

Mr. Smart’s current application is not secured at all and written for exactly one user. In the future, any user contacts the application and is challenged with a login page. They enter their credentials (login and password) and are presented with exactly their data. All of the stories above apply, but only to their data. No regular user can see or modify any data but their own.

Additional Table Features
-------------------------

Mr. Smart wants the tables to be more responsive. When a user requests one of the table pages (currency, country), they are presented with a list of countries each with a checkbox next to them. They check each of the countries that they have already visited and are given the opportunity to Visit (or Collect, in the case of currency) from the table page. Upon using the Visit functionality, only the checked rows and the chart are updated, not the rest of the page.
Mr. Smart also wants to be able to filter currencies and countries based upon their name. A user comes to the table page and is presented with a list of all entities. The user can enter a string and filter based upon it. When told to do so, the page shows all entities with a name containing the entered string. No page reload occurs. When the filter is cleared, all entities are displayed again.
Finally, Mr. Smart would also like a ‘Check All’ option to use with his filtering. Mr. Smart filters for a particular value. Given the results of the filter, he uses check all to check every checkbox displayed. He then clicks Visit (or Collect, in the case of currency) to modify all checked entities.

Additional Charting Features
----------------------------

Mr. Smart is interested in seeing his progress over time for both visitation and collection. A line graph is displayed over each table showing number of currencies (or countries depending upon the page) versus time (the date). Whenever he visits a
country or collects a currency, the line graph is updated to reflect the new state of his collection.

Assignment guideline.
=====================================

Production readiness
--------------------

Please, make sure your output is production ready:

* It has all changes committed with reasonable commit messages
* It does not break existing tests, both unit tests and cucumber features.
* It tests new functionality.
* At all times test routines should pass 'green'
  * rake test
  * cucumber
* It works from scratch. Literally, it should work after following command sequence
  * rake db:reset
  * rails server
* It has a sample user with collection history
* What claimed as done is fully working. Better to have 2 working features than 3 not working.
* Don't try to overengineer the solution

Additional code purity checks
-----------------------------

* No inline JavasScript in views
* Thin controllers where possible
* Scopes instead of stacked find or where calls.
