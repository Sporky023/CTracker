module CountriesHelper
  def visited_status_for(country)
    country.visited_by_user?(current_user) ? 'Visited' : 'Not Visited'
  end
end
