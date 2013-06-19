Assumptions and Decisions Made in This Assignment
=================================================

4:34 pm:  Use ruby 1.8.7 (not REE)
  Because I haven't been able to get debugger or pry working with REE since I installed it.
  Normally I would take the time to solve this, but it's more important that I get an example of what I can do in six hours.

4:48 pm: Actually, let's update to Ruby 1.9.3
  I tried to update cucumber, capybara, and cucumber-rails.
  This failed because the most recent versions of some gems (in this case nokogiri) won't work without latest version of Ruby.
  This project is so young that it's worth moving to the latest of everything, if possible.
  Going with patch level 429 since Heroku supports that for 1.9.3.
  I'm not going to use Ruby 2.0 because I haven't studied it yet.

5:44 pm:
  Okay, so I've spent about 1.25 hours so far.
  The app is on a good footing:
    ruby 1.9.3-p429
    rails 3.2.13
    all other gems updated
  Now ready to start changing features.
  I'm going to start by implementing the following stories:
    Feature: User Accounts
      Scenario: User signs up (using Devise, no confirmation since we're not messing with email right now)
      Scenario: User signs in

    Story: User browses countries (will be a modification of the "manage countries" feature)
      - this will include some refactoring to move tracking out of the Country model into a Visit model

7:06 pm: Use id instead of nonstandard primary keys on Country and Currency
  Because having to use special commands for every association is just one more thing to remember
  And I can't think of a reson to use a nonstandard primary_key
