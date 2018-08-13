class ApplicationController < ActionController::Base
  # Authenticate token before process requests
  before_action :authenticate

  # Unless authenticate return unauthorized status
  def authenticate
    if request.headers["HTTP_AUTHORIZATION"].present?
      token = request.headers["HTTP_AUTHORIZATION"].split('Token token=').last
      if token != '0x3f01b98dce38ab266910c5527cb011602514bf88ee1a9e076fd071d78c54e319'
        unauthorize
      end
    else
      unauthorize
    end
  end

  # Return 401 status
  def unauthorize
    return render json: 'Bad credentials', status: 401
  end
end
