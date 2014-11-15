namespace :db do
  

  desc "Update the database using files found under the MUSIC_CAST_DIR directory"
  task update: :environment do
    require 'id3tag'

    def update_directory(dir)
      Dir.glob("#{dir}/*").each do |e|
        if File.directory? e
          update_directory(e)
        elsif e.end_with? ".mp3"
          update_file(e)
        end
      end
    end

    def update_file(file)
      # TODO instead of searching the database,
      #      could compare the timestamp against the
      #      last time we updated
      if Track.find_by(path: file).nil?
        tag = ID3Tag.read(File.open(file))

        
        missing = []
        # TODO probably need to look at the explicit tag ids and
        #      process them accordingly
        #      in particular, make sure to get the right artist,
        #      and apparently genre is often busted
        [:artist, :album, :title].each do |field|
          value = tag.send(field)
          missing << field.to_s if value.nil? or value.empty?
        end

        if missing.empty?
          logger.info "Updating from file #{file}"
          artist = Artist.find_or_create_by(name: tag.artist.strip)
          album = artist.albums.find_or_create_by(name: tag.album.strip)
          album.tracks.find_or_create_by(name: tag.title.strip, path: file)
        else
          logger.error "#{file} missing: #{missing.join(",")}"
        end
      end
    end

    raise "MUSIC_CAST_DIR not defined" unless ENV.has_key? "MUSIC_CAST_DIR"
    music_cast_dir = ENV["MUSIC_CAST_DIR"]
    raise "#{music_cast_dir} is not a directory" unless File.directory? music_cast_dir

    update_directory(music_cast_dir)
  end

end
