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

        if tags['artist'].nil?
          next
        end

        str_artist = tags['artist'].encode('UTF-8').strip
        artist = Artist.find_by_name(str_artist)
        if artist.nil?
          artist = Artist.new
          begin
            artist.name = str_artist
          rescue
            artist.name = 'UNICODE ERROR'
          end
          artist.save!
        end

        str_album = tags['album'].encode('UTF-8').strip
        album = Album.find_by_name_and_artist_id(str_album, artist.id)
        if album.nil? and !tags['album'].nil?
          album = Album.new
          begin
            album.name = str_album
          rescue
            album.name = 'UNICODE ERROR'
          end
          album.year = tags['year']
          album.artist = artist
          album.save!
        end

        str_song = tags['title'].encode('UTF-8').strip
        song = Song.new
        begin
          song.title = str_song
        rescue
          song.title = 'UNICODE ERROR'
        end
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
