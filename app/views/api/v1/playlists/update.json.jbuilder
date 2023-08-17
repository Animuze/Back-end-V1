json.message "Playlist was updated successfully"
json.data do
  json.partial! "playlist", playlist: @playlist
end
