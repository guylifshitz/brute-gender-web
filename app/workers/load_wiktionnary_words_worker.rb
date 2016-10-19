  # LoadWiktionnaryWordsWorker.perform_async
class LoadWiktionnaryWordsWorker
  include Sidekiq::Worker
  def perform
    Processing::WordProcessing.load_wikitionnary_words
  end
end
