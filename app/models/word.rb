class Word < ActiveRecord::Base
  # serialize :definition_en

  # has_many :level_words
  # has_many :levels, through: :level_words

  # has_many :word_scores


  # has_many :category_words

  def self.find_words word
    query = 'text = :w OR "Afpfp" = :w OR "Afpfs" = :w OR "Afpmp" = :w OR "Afpms" = :w OR
    "Nc?p" = :w OR "Nc?s" = :w OR "Ncfp" = :w OR "Ncfs" = :w OR "Ncmp" = :w OR "Ncms" = :w OR
    "Npfp" = :w OR "Npfs" = :w OR "Npms" = :w OR "Npmp" = :w OR
    "Vmn----" = :w OR "Vmpp---" = :w OR
    "Vmps-pf" = :w OR "Vmps-pm" = :w OR "Vmps-sf" = :w OR "Vmps-sm" = :w  OR
    "Vmcp1p-" = :w OR "Vmcp1s-" = :w OR "Vmcp2p-" = :w OR "Vmcp2s-" = :w OR "Vmcp3p-" = :w OR "Vmcp3s-" = :w OR
    "Vmif1p-" = :w OR "Vmif1s-" = :w OR
    "Vmif2p-" = :w OR "Vmif2s-" = :w OR "Vmif3p-" = :w OR "Vmif3s-" = :w OR
    "Vmii1p-" = :w OR "Vmii1s-" = :w OR "Vmii2p-" = :w OR "Vmii2s-" = :w OR "Vmii3p-" = :w OR "Vmii3s-" = :w OR
    "Vmip1p-" = :w OR "Vmip1s-" = :w OR "Vmip2p-" = :w OR "Vmip2s-" = :w OR "Vmip3p-" = :w OR "Vmip3s-" = :w OR
    "Vmis1p-" = :w OR "Vmis1s-" = :w OR "Vmis2p-" = :w OR "Vmis2s-" = :w OR "Vmis3p-" = :w OR "Vmis3s-" = :w OR
    "Vmmp1p-" = :w OR "Vmmp2p-" = :w OR "Vmmp2s-" = :w OR
    "Vmsi1p-" = :w OR "Vmsi1s-" = :w OR "Vmsi2p-" = :w OR "Vmsi2s-" = :w OR "Vmsi3p-" = :w OR "Vmsi3s-" = :w OR
    "Vmsp1p-" = :w OR "Vmsp1s-" = :w OR "Vmsp2p-" = :w OR "Vmsp2s-" = :w OR "Vmsp3p-" = :w OR "Vmsp3s-" = :w'

    ps = Word.where(query, :w => word)
    ps
  end

end
