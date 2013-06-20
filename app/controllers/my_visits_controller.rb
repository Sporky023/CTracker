class MyVisitsController < ApplicationController
  before_filter :redirect_to_home_unless_authenticated

  def create
    current_user.countries << Country.find(params[:country_ids])
    current_user.save
    redirect_to next_url
  end

  private

  def next_url
    country_path(params[:country_ids].first)
  end
end
