json.message "Song successfully removed to Playlist"
json.data do
  json.partial! "playlist", playlist: @playlist_song.playlist
end
