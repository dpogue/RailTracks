require 'mp3info'

namespace :tracks do
  desc "populate the database with music"
  task :fetch => :environment do
    Library.all.each do |lib|
      p = lib.path
      p += '/' unless p.end_with?('/')
      p += '**/' if lib.recursive
      Dir.glob(p + '*.mp3').each do |f|
        print f + ' :: '
        tags = Mp3Info.open(f, :encoding => 'utf-8').tag

        if tags['artist'].nil? or tags['title'].nil?
          puts "Missing tag information"
          next
        end

        str_artist = tags['artist']
        begin
          str_artist = str_artist.encode('UTF-8').strip unless str_artist.nil?
        rescue
          puts "INVALID UTF8 TAG: Artist"
          next
        end

        artist = Artist.find_by_name(str_artist)
        if artist.nil?
          artist = Artist.new
          artist.name = str_artist
          artist.save!
        end

        str_album = tags['album']
        begin
          str_album = str_album.encode('UTF-8').strip unless str_album.nil?
        rescue
          # We'll cheat a bit if the album is invalid, just use no album
          str_album = nil
        end

        album = Album.find_by_name_and_artist_id(str_album, artist.id)
        if album.nil? and !str_album.nil?
          album = Album.new
          album.name = str_album
          album.year = tags['year']
          album.artist = artist
          album.save!
        end

        str_song = tags['title']
        begin
          str_song = str_song.encode('UTF-8').strip unless str_song.nil?
        rescue
          puts "INVALID UTF8 TAG: Title"
          next
        end

        song = Song.find_by_file(f)
        song = Song.new if song.nil?
        song.title = str_song
        song.track = tags['tracknum']
        song.artist = artist
        song.album = album
        song.library = lib
        song.file = f
        song.save!

        puts song.title+' ('+artist.name+(album.nil? ? '' : ' : '+album.name)+')'
      end
    end
  end
end
