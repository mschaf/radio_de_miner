class StationUpdatePageWorker
  include Sidekiq::Worker

  def perform(per_page, page)
    Station.update_page_from_api(per_page: per_page, page: page)
  end

end
