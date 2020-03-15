class PlayedSong < ApplicationRecord

  belongs_to :station

  def self.update_playing_songs_for_stations(station_ids)
    batch_size = 200
    batches = station_ids.in_groups_of(batch_size)
    batches.each do |batch|
      batch.compact!
      UpdatePlayingSongsBatchWorker.perform_async(batch)
    end
  end

  def self.update_playing_songs_for_stations_batch(station_ids)
    PlayedSong.transaction do
      station_radio_de_id_mapping = Station.where(id: station_ids).pluck(:radio_de_id, :id).to_h
      newest_stream_title_per_station_id = PlayedSong.select('DISTINCT ON (station_id) station_id, stream_title')
                                                     .where(station_id: station_ids)
                                                     .order(created_at: :asc)
                                                     .pluck(:station_id, :stream_title)
                                                     .to_h
      currently_playing_for_station_ids = RadioDeApi.currently_playing_for_station_ids(station_radio_de_id_mapping.keys)

      played_songs_to_create = []

      currently_playing_for_station_ids.each do |radio_de_station_id, current_song|
        next unless current_song

        station_id = station_radio_de_id_mapping[radio_de_station_id.to_i]
        newest_stream_title = newest_stream_title_per_station_id[station_id]

        next if current_song['streamTitle'] == newest_stream_title

        attributes = {
            station_id: station_id,
            stream_title: current_song['streamTitle'],
            artist: current_song['artistName'],
            title: current_song['songName'],
            album: current_song['albumName'],
            genre: current_song['genre'],
            cover_image_url: current_song['coverImageUrl100'],
        }.map{ |k, v| v.present? ? [k, v] : [k, nil] }.to_h
        attributes[:media_release_date] = current_song['mediaReleaseDate'].zero? ? nil : Time.at(current_song['mediaReleaseDate'])
        played_songs_to_create << attributes
      end

      PlayedSong.import! played_songs_to_create
    end
  end

end