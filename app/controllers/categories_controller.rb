class CategoriesController < ApplicationController
  before_action :authenticate_user!
  helper_method :sort_column, :sort_direction

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @levels = @category.levels
    @levels = @levels.sort_by(&:updated_at)

    # @words = []
    # @level.level_words.sort_by(&:updated_at).each do |lw|
    #   @words.push(lw.word)
    # end

    @level_completion = {}

    @levels.each do |level|
      highest_level_completion = 0
      LevelInstance.where(:level_id => level.id).each do |level_instance|
        if level_instance[:correct_completion_percent] > highest_level_completion
          highest_level_completion = level_instance[:correct_completion_percent]
        end
      end
      @level_completion[level.id] = highest_level_completion
    end
  end

  def destroy
    ap params
    @category = Category.find(params[:id])
    destroy_existing_levels(@category)
    ap @category.category_words  
    @category.category_words.destroy_all
    @category.destroy
    redirect_to categories_path
  end

  def update
    if category_params
      @category = Category.find(params[:id])
      @category.update_attributes!(category_params)
    else
      cat_word = CategoryWord.find(params[:cat_word_id])
      cat_word.update_attributes({:include_word => !cat_word[:include_word]})
    end

    redirect_to edit_category_path({:id=>params[:id]})
  end

  def edit
    @category = Category.find(params[:id])

    @selected_words = []
    @removed_words = []
  
    @category.category_words.each do |w|
      if w.word[:frequency_lemma] != nil
        if w.include_word
          @selected_words.push(w)
        else
          @removed_words.push(w)
        end
      else
        @selected_words.push(w)
      end
    end

    if params[:sort] == "frequency"
      @selected_words = @selected_words.sort_by { |k| k.word[:frequency_lemma] }
      @removed_words = @removed_words.sort_by { |k| k.word[:frequency_lemma] }
    else
      @selected_words = @selected_words.sort_by { |k| k[params[:sort]] }
      @removed_words = @removed_words.sort_by { |k| k[params[:sort]] }
    end


    if params[:direction] == "desc"
      @selected_words = @selected_words.reverse!
      @removed_words = @removed_words.reverse!
    end

  end

  def new
    @category = Category.new

    @selected_words = []
    @removed_words = []
  end

  def find_words

    ap "find_words"
    ap params

    if params[:category][:id] != nil and params[:category][:id] != ""
      category = Category.find(params[:category][:id])
      category.update(category_params)
    else
      category = Category.create(category_params.merge({:word_frequency_maximum => 1000000}))
    end


    category.category_words.each do |cat_word|
      cat_word.destroy
    end

    HardWorker.perform_async(category.id)
    redirect_to edit_category_path({:id=>category.id})
  end

  def update_range
    category = Category.find(params[:category][:id])
    word_frequency_maximum = category_params[:word_frequency_maximum].to_i
    category.update_attribute(:word_frequency_maximum, word_frequency_maximum)
    category.save!
    Processing::WordSourceCounter.select_included_words(category)
    redirect_to edit_category_path({:id=>params[:category][:id]})
  end

  def create_levels
    redirect_to categories_path

    @category = Category.find(params[:category_id])

    destroy_existing_levels(@category)

    @selected_words = []
  
    @category.category_words.each do |w|
      if w.include_word
        @selected_words.push(w)
      end
    end

    @selected_words = @selected_words.sort_by &:url_frequency
    @selected_words = @selected_words.reverse!

    @level_size = @selected_words.count
    if @selected_words.count > 200
      @level_size = 50
    end

    counter =0
    l = nil

    # ap @selected_words

    @selected_words.each do |wc|
      w = wc.word
      if counter % @level_size == 0
        l = Level.create({:name=>"Level #{counter/@level_size + 1}", :description => "Words you'll see.", :category => wc.category})
      end
      LevelWord.create({:level => l, :word => w})
      counter = counter + 1
    end
  end

  def create_wrong_words_level
      category = Category.find(params[:category_id])
      word_scores = WordScore.where({:user_id=>current_user, :category => category})

      wrong_words = []
      word_scores.each do |ws|
        if ws.correct == false
          wrong_words.push(ws.word)
        end
      end


      l = Level.create({:name=>"Wrong words: #{category[:name]}", :description => "Words you got wrong.", :category => category})

      wrong_words.uniq.each do |w|
        LevelWord.create({:level => l, :word => w})
      end

      redirect_to category_level_path(category, l)

      # @level_instance = LevelInstance.create({:user => current_user, :category => category, :complete_count => 0, :correct_completion_percent => 0, :word_scores => wrong_words})
      # success = @level_instance.save
      # redirect_to level_instance_run_index_path(:level_instance_id => @level_instance.id)
  end

  private

  def destroy_existing_levels category
    Level.where({:category => category}).each do |level|
      level.level_words.destroy_all

      level.level_instances.each do |li|
        li.word_scores.destroy_all
      end

      level.level_instances.destroy_all
    end

    Level.destroy_all({:category => category})
  end

  def category_params
    if params[:category]
      params.require(:category).permit(:word_sources, :name, :word_frequency_maximum, :word_score_maximum)
    else 
      false
    end
  end
  
  def sort_column
    if CategoryWord.column_names.include?(params[:sort]) or Word.column_names.include?(params[:sort])
      params[:sort]
    else
      "name"
    end
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end