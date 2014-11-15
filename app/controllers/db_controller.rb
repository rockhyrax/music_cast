require 'id3tag'

class DbController < ApplicationController
  # Dummy action if update or clean is accessed from
  # somewhere other than locahost
  def invalid
  end

  # Traverse the directory specified by MUSIC_CAST_DIR,
  # looking for new .mp3 files, and adding the information to
  # the database
  def update
    raise "MUSIC_CAST_DIR not defined" unless ENV.has_key? "MUSIC_CAST_DIR"

    music_cast_dir = ENV["MUSIC_CAST_DIR"]

    raise "#{music_cast_dir} is not a directory" unless File.directory? music_cast_dir

    logger.info "Updating database from #{music_cast_dir}"
    update_directory(music_cast_dir)
  end

  # Drop all rows from all tables
  def clean
    # TODO is there a better way to do this?
    Track.delete_all
    Album.delete_all
    Artist.delete_all
    Genre.delete_all
  end


  private
  def update_directory(dir)
    logger.info "Updating from directory #{dir}"
    Dir.glob("#{dir}/*").each do |e|
      if File.directory? e
        update_directory(e)
      elsif e.end_with? ".mp3"
        update_file(e)
      end
    end
  end

  def update_file(file)
    if Track.find_by(path: file).nil?
      tag = ID3Tag.read(File.open(file))

      missing = []
      # TODO probably need to look at the explicit tag ids and
      #      process them accordingly
      #      in particular, make sure to get the right artist,
      #      and apparently genre is often busted
      [:genre, :artist, :album, :title].each do |field|
        value = tag.send(field)
        missing << field.to_s if value.nil? or value.empty?
      end

      if missing.empty?
        logger.info "Updating from file #{file}"
        genre = Genre.find_or_create_by(name: tag.genre.strip)
        artist = genre.artists.find_or_create_by(name: tag.artist.strip)
        album = artist.albums.find_or_create_by(name: tag.album.strip)
        album.tracks.find_or_create_by(name: tag.title.strip, path: file)
      else
        logger.error "#{file} missing: #{missing.join(",")}"
      end
    else
      logger.info "Skipping pre-existing file #{file}"
    end

  end
end
