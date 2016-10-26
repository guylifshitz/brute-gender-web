class WordScoresController < ApplicationController

  before_action :authenticate_user!

  def index

    all_word_scores = WordScore.where({:user_id => current_user, :seen => true})

    words_scores = {}

    all_word_scores.each do |word_score|
      if words_scores[word_score.word[:word]]
        words_scores[word_score.word[:word]].push(word_score)
      else
        words_scores[word_score.word[:word]] = [word_score]
      end
    end

    @output_words = []
    words_scores.each do |word_score|
      correct_count = 0
      word_score[1].each do |word_score|
        if word_score[:correct]
          correct_count += 1
        end
      end
      @output_words.push({:word=>word_score[0], :gender => word_score[1].first.word[:gender], :count => word_score[1].count, :correct_count=>correct_count})
    end
  end
end
