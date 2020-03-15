class UpdatePlayingSongsBatchWorker
  include Sidekiq::Worker

  def perform(station_ids)
    PlayedSong.update_playing_songs_for_stations_batch(station_ids)
  end

end
