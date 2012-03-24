class IndexController < ApplicationController
  def index
    @cities = City.find(:all)
  end

  def city
    @cities = City.find(:all)
    @city = City.find(params[:id])

    @clubs = @city.clubs
  end
end
