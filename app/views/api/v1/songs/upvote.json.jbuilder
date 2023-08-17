json.message "Song liked successfully"
json.data do
  json.id @song.id
  json.likes @song.get_upvotes.size
  json.dislike @song.get_downvotes.size
end
