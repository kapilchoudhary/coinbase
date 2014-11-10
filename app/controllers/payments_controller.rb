class PaymentsController < ApplicationController

  def index
    @coinbase = Coinbase::Client.new(ENV['COINBASE_API_KEY'], ENV['COINBASE_API_SECRET'])
  end

  def get_code
    url = "https://www.coinbase.com/oauth/token?grant_type=authorization_code&code=".concat(params['code']).concat("&redirect_uri=https://coinbase-newt.herokuapp.com/payments/get_code&client_id=").concat(ENV['COINBASE_CLIENT_ID']).concat("&client_secret=").concat(ENV['COINBASE_CLIENT_SECRET'])
    response = HTTParty.post( url )
    
    if response.success?
      user_credentials = {
          :access_token => response.parsed_response["access_token"],
          :refresh_token => response.parsed_response["refresh_token"],
          :expires_at => response.parsed_response["expires_in"]
      }

      coinbase = Coinbase::OAuthClient.new(ENV['COINBASE_CLIENT_ID'], ENV['COINBASE_CLIENT_SECRET'], user_credentials)

      @pr = coinbase.send_money 'msaraf07@gmail.com', 0.0001
    else
      puts "======FAILED=======FAILED=========FAILED======FAILED======FAILED======FAILED=======FAILED=====FAILED=========FAILED========"
      #flash[:error] = "Not Authorized"
    end
  end
end
