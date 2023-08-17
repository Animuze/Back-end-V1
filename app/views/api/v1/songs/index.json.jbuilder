json.data do
  json.most_liked_song do
    json.array! @most_liked_song, partial: 'song', as: :song
  end

  json.new_songs do
    json.array! @new_songs, partial: 'song', as: :song
  end

  json.all_songs do
    json.array! @songs, partial: 'song', as: :song
  end
  
end
