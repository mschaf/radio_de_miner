class StationUpdateWorker
  include Sidekiq::Worker

  def perform
    Station.update_all_from_api
  end

end
