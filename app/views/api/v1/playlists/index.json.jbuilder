json.data do
  json.array! @playlists, partial: 'playlist', as: :playlist
end
