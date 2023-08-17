class Playlist < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  scope :admin, -> (current_admin) { where(admin_id: current_admin.id) }


  after_save :deactivate_previous_playlists

  belongs_to :admin, optional: true
  belongs_to :user, optional: true
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs
  validates :title, presence: true, uniqueness: { scope: [:admin_id, :user_id] }

  enum status: [:active, :deactivate]

  validates :title, presence: true, uniqueness: { scope: :admin_id }

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

  def self.search_playlist(params, per_page, current_admin)
    @playlists = params[:query].present? ? Playlist.search(params[:query]).records.admin(current_admin) : current_admin.playlists
    @playlists.paginate(page: params[:page], per_page: per_page)
  end

  private

  def deactivate_previous_playlists
    if self.active?
      user = self.admin.present? ? self.admin : self.user
      previous_playlists = user.playlists.where.not(id: self.id)
      previous_playlist = previous_playlists.where(status: 'active').last
      previous_playlists.update_all(status: "deactivate")
      Playlist.where(id: previous_playlist.id).import if previous_playlist.present?
    end
  end

  def to_json
    as_json.merge({
      mp3: url_for(self.song.music),
    })
  end
end
