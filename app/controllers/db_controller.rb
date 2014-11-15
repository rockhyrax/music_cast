class DbController < ApplicationController
  # Dummy action if update or clean is accessed from
  # somewhere other than locahost
  def invalid
  end

  def update
  end

  def clean
    # TODO is there a better way to do this?
    Track.delete_all
    Album.delete_all
    Artist.delete_all
    Genre.delete_all
  end
end
