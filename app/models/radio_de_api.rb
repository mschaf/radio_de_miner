class RadioDeApi
  class << self

    def station_pages_count(per_page: 20)
      result = get('search/stations', pageindex: 1, sizeperpage: per_page, query: '')
      result.parsed_response['numberPages']
    end


    def stations(per_page: 20, page: 0)
      result = get('search/stations', pageindex: page + 1, sizeperpage: per_page, query: '')
      result['categories'][0]['matches']
    end

    def currently_playing_for_station_ids(station_ids)
      result = get('search/nowplayingbystations', numberoftitles: 1, stations: station_ids.join(','))
      result.parsed_response.map{ |k,v| [k, v[0]] }.to_h
    end

    private

    def get(path, params = {})
      path = base_uri + path
      params[:apikey] = api_key
      params[:_] = Time.now.to_i
      response = HTTParty.get path, query: params # , debug_output: $stdout
      raise unless response.success?
      response
    end

    def api_key
      Rails.configuration.radio_de_api_key
    end

    def base_uri
      'https://api.radio.de/info/v2/'
    end

  end
end