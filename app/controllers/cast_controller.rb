class CastController < ApplicationController
  def cast
    @hostname = request.host_with_port
  end
end
