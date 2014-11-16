class FetchController < ApplicationController
  def artist
  end

  def album
  end

  def track
    track_id = params[:id].to_i
    track = Track.find(track_id)
    send_track(track)
  end

  def random
    track = Track.offset(rand(Track.count)).first
    send_track(track)
  end

  private
  def send_track(track)
    send_file(track.path, :type => "audio/mpeg", :disposition => "inline")
  end
end
