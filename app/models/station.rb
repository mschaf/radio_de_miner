class Station < ApplicationRecord

  has_many :played_songs

  def self.update_all_from_api
    per_page = 500
    pages_count = RadioDeApi.station_pages_count(per_page: per_page)

    (0...pages_count).each do |page_index|
      StationUpdatePageWorker.perform_async(per_page, page_index)
      puts "#{page_index}/#{pages_count}"
    end
  end

  def self.update_page_from_api(per_page:, page:)
    raw_stations = RadioDeApi.stations(per_page: per_page, page: page)
    station_hashes = []
    raw_stations.each do |raw_station|
      station_hashes << {
        radio_de_id: raw_station['id'],
        continent: raw_station['continent']&.[]('value'),
        country: raw_station['country']&.[]('value'),
        city: raw_station['city']&.[]('value'),
        genres: raw_station['genres'].map { |genre| genre['value'] },
        name: raw_station['name']['value'],
        logo_url: raw_station['logo175x175']
      }
    end
    Station.import station_hashes, validate: false, on_duplicate_key_update: { conflict_target: [:radio_de_id], columns: [:continent, :country, :city, :genres, :name, :logo_url] }
  end

end