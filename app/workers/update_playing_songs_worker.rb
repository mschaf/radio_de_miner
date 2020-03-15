class UpdatePlayingSongsWorker
  include Sidekiq::Worker

  def perform
    PlayedSong.update_playing_songs_for_stations(Station.where(country: "Deutschland").pluck(:id))
  end

end
