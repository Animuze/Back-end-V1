class Song < ApplicationRecord
  require 'mp3info'
  has_one_attached :music
  has_one_attached :image

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  acts_as_votable

  validates :music,  presence: true
  validates :image,  presence: true
  validates :title,  presence: true
  validates :artist, presence: true
  validates :genre,  presence: true
  validates :name,   presence: true
  validates :album,  presence: true
  validates :year,   presence: true

  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs

  has_many :user_like_songs, dependent: :destroy
  has_many :users, through: :user_like_songs

  before_save do
    if self.music.attached?
      ext = '.' + self.music.blob.filename.extension
      self.music.blob.update(filename: self.name + ext)
    end
  end

  def mp3
    Rails.application.routes.url_helpers.url_for(music)
  end

  def self.search(query)
    __elasticsearch__.search(

    {
      query: {
        multi_match: {
          query: query
        }
      },
      size: 1000
    })
  end

  def update_metadata(song_params)
    return unless song_params[:music].present?

    Mp3Info.open(check_music_params(song_params)) do |mp3info|
      mp3info.tag.title = song_params[:title]
      mp3info.tag.artist = song_params[:artist]
      mp3info.tag.album = song_params[:album]
      mp3info.tag.genre_s = song_params[:genre]
      mp3info.tag.year = song_params[:year]
      self.duration = Time.at(mp3info.length).utc.strftime "%M:%S"

      if song_params[:image].present?
        mp3info.tag2.remove_pictures
        mp3info.tag2.add_picture(song_params[:image].read)
      else
        return if self.image.attached? && song_params[:music].nil?
        pictures = mp3info.tag2.pictures
        pictures.each do |description, data|
          File.binwrite('cover_image', data)
        end

        self.image.attach(io: File.open("cover_image"), filename: "#{song_params[:title]}.png", content_type: 'image/png')

        begin
          File.open("cover_image", 'r') do |f|
            File.delete(f)
          end
        rescue Errno::ENOENT
        end
      end
    end
  end

  def self.search_songs(params, per_page)
    @songs = params[:query].present? ? Song.search(params[:query]).records : Song.all
    @songs.paginate(page: params[:page], per_page: per_page)
  end

  private

  def check_music_params(song_params)
    return song_params[:music] || self.music.service.send(:object_for, self.music.key).public_url
  end
end
