json.message "Song successfully added to Playlist"
json.data do
  json.partial! "playlist", playlist: @playlist_song.playlist
end
