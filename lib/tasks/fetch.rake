require 'mp3info'

namespace :tracks do
  desc "populate the database with music"
  task :fetch => :environment do
    Library.all.each do |lib|
      p = lib.path
      Dir.glob(p + (p.end_with?('/') ? '' : '/') + '**/*.mp3').each do |f|
        print f + ' :: '
        tags = Mp3Info.open(f, :encoding => 'utf-8').tag

        if tags['artist'].nil?
          next
        end

        artist = Artist.find_by_name(tags['artist'])
        if artist.nil?
          artist = Artist.new
          begin
            artist.name = tags['artist'].encode('UTF-8')
          rescue
            artist.name = 'UNICODE ERROR'
          end
          artist.save!
        end

        album = Album.find_by_name_and_artist_id(tags['album'], artist.id)
        if album.nil? and !tags['album'].nil?
          album = Album.new
          begin
            album.name = tags['album'].encode('UTF-8')
          rescue
            album.name = 'UNICODE ERROR'
          end
          album.year = tags['year']
          album.artist = artist
          album.save!
        end

        song = Song.new
        begin
          song.title = tags['title'].encode('UTF-8')
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
