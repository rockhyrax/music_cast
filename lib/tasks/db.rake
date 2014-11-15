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

        fields = {
          :year => 0,
          :track_nr => 0,
          :disc_nr => 1,
        }

        missing = []

        # These fields are required, and are strings
        [:artist, :album, :title].each do |field|
          value = tag.send(field)
          if value.nil? or value.empty?
            missing << field.to_s
          else
            fields[field] = value.strip
          end
        end

        # These fields have valid defaults, and are numbers
        [:year, :track_nr].each do |field|
          value = tag.send(field)
          unless value.nil? or value.empty?
            fields[field] = value.strip.to_i(10)
          end
        end

        unless tag.get_frame(:TPOS).nil?
          fields[:disc_nr] = tag.get_frame(:TPOS).content.to_i(10)
        end

        if missing.empty?
          artist = Artist.find_or_create_by(name: fields[:artist])
          album = artist.albums.find_by(name: fields[:album])
          if album.nil?
            album = artist.albums.create(name: fields[:album], year: fields[:year])
          end
          album.tracks.create(name: fields[:title], path: file,
                              track_num: fields[:track_nr],
                              disc_num: fields[:disc_nr])
        else
          puts "#{file} missing: #{missing.join(",")}"
        end
      end
    end

    raise "MUSIC_CAST_DIR not defined" unless ENV.has_key? "MUSIC_CAST_DIR"
    music_cast_dir = ENV["MUSIC_CAST_DIR"]
    raise "#{music_cast_dir} is not a directory" unless File.directory? music_cast_dir

    update_directory(music_cast_dir)
  end

end
