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
