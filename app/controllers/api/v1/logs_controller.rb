class Api::V1::LogsController < ApplicationController
  def index
    logs = LogDatum.all
    render json: logs, status: :ok
  end

  def show
  end
end
