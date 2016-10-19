class HardWorker
  include Sidekiq::Worker
  def perform(category_id)
    category = Category.find(category_id)
    urls = category[:word_sources].split(",")
    ap urls
    Processing::WordSourceCounter.run(category, urls)
  end
end
