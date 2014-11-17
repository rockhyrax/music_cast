music_cast
==========

Rails app for streaming music to a Chromecast device

Prerequisites
=============

Ruby, including dev packages (tested with version 1.9.3)

Rails (tested with version 4.1.4)

sqlite3, including dev packages

Installation
============

    git clone https://github.com/rockhyrax/music_cast.git <target directory>
    cd <target directory>
    ./bin/bundle install
    ./bin/rake db:migrate

Setup
=====

To populate the database with information about music files in a directory, run:
    ./bin/rake db:update MUSIC_CAST_DIR=<music_directory>
This can be run multiple times, either to pull in a new directory, or to look for new files in the same directory.
