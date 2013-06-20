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

7:58 pm:
  Countries are now tracking users separately.  Along the way I got FactoryGirl installed.
  Next up is to do a quick check to make sure controllers always redirect to home unless we're authenticated.

8:30 pm:
  I'm starting to get seriously tired.  In my usual working life I try not to code for more than three hours at a time.
  Normally this would be the point where I would put this down and do something else for a while.
  But I will push ahead.  My quality and precision may drop after this point.

9:12 pm: Decision: remove "edit" workflow
  (a) Users should not be able to edit country or currency records
  (b) In planning for the multiple checkbox functionality,
      a request will go to POST /my_visits ("my" implies current user)
      the params will look like:  params = {:country_ids => [3, 5, 6]}.
      For now, I will simply link to create a single-element array to create my visits

9:39 pm:
  Okay that's gone.  Now we're in good shape to move directly into the advanced table features.
  First I'm gonna tackle the filtering.  That's easy as pie, and I should have it in place before I start messing with "check all".


