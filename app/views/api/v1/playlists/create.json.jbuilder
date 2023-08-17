json.message "Playlist was created successfully"
json.data do
  json.partial! "playlist", playlist: @playlist
end
