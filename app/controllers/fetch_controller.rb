class FetchController < ApplicationController
  def artists
    @artists = Artist.order(:name).select(:id, :name)

    respond_to do |format|
      format.html
      format.json { render :json => @artists }
    end
  end

  def albums
    artist_id = params[:artist_id].to_i
    artist = Artist.find(artist_id)
    @albums = artist.albums.order(:year).select(:id, :name, :year)

    respond_to do |format|
      format.html
      format.json { render :json => @albums }
    end
  end

  def tracks
    if params.has_key? :album_id
      album_id = params[:album_id].to_i
      album = Album.find(album_id)
      @tracks = album.tracks.order(:disc_num, :track_num).select(:id, :name, :disc_num, :track_num)
    elsif params.has_key? :artist_id
      artist_id = params[:artist_id].to_i
      artist = Artist.find(artist_id)
      @tracks = artist.tracks.order(:name).select(:id, :name, :disc_num, :track_num)
    else
      raise "Query must specify artist_id or album_id"
    end

    respond_to do |format|
      format.html
      format.json { render :json => @tracks }
    end
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
