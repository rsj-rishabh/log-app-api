class Api::V1::HealthCheckController < ApplicationController
  rescue_from(Exception) { render head: 503 }

  def index
    render head: 200
  end

  def show
    render head: 200
  end
end
