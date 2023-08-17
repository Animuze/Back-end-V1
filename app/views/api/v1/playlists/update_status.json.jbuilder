json.message "Playlist was activated successfully"
json.data do
  json.partial! "playlist", playlist: @playlist
end
