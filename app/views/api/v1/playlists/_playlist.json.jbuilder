json.id   playlist.id
json.name playlist.title
json.status playlist.status

json.songs playlist.songs do |song|
  json.partial! 'api/v1/songs/song', song: song
end
