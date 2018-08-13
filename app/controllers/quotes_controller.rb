class QuotesController < ApplicationController
  include QuoteCrawler

  # GET /quotes/:search_tag
  # Search quote by tag
  def search
    @quotes = QuoteCrawler.search_crawler(params[:search_tag])
    render json: @quotes, status: :ok
  end
end
