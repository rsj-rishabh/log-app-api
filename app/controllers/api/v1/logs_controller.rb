class Api::V1::LogsController < ApplicationController
  def index
    
    @logs = LogDatum.paginate(page: params[:page], per_page: 10)
    total_pages = @logs.total_pages

    response.headers['X-Total-Pages'] = total_pages.to_s
    render json: @logs, status: :ok
  end

  def show
  end
end
