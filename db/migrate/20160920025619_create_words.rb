class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|

      t.string   :text
      # t.string   :word_plural

      t.string   :pos
      t.boolean  :locution

      t.jsonb :definitions
      t.jsonb :translations
      t.jsonb :semantic_relations
      t.jsonb :morphos
      t.text :alternative_forms, array: true, default: []

      t.string  :gender
      t.string  :plural

      t.integer  :frequency

      t.timestamps null: false

      t.string 'Afpfp'
      t.string 'Afpfs'
      t.string 'Afpmp'
      t.string 'Afpms'

      t.string 'Nc?p'
      t.string 'Nc?s'
      t.string 'Ncfp'
      t.string 'Ncfs'
      t.string 'Ncmp'
      t.string 'Ncms'

      t.string 'Npfp'
      t.string 'Npfs'
      t.string 'Npms'
      t.string 'Npmp'

      t.string 'Vmn----' 

      t.string 'Vmpp---'

      t.string 'Vmps-pf'
      t.string 'Vmps-pm'
      t.string 'Vmps-sf'
      t.string 'Vmps-sm'

      t.string 'Vmcp1p-'
      t.string 'Vmcp1s-'
      t.string 'Vmcp2p-'
      t.string 'Vmcp2s-'
      t.string 'Vmcp3p-'
      t.string 'Vmcp3s-'

      t.string 'Vmif1p-'
      t.string 'Vmif1s-'
      t.string 'Vmif2p-'
      t.string 'Vmif2s-'
      t.string 'Vmif3p-'
      t.string 'Vmif3s-'

      t.string 'Vmii1p-'
      t.string 'Vmii1s-'
      t.string 'Vmii2p-'
      t.string 'Vmii2s-'
      t.string 'Vmii3p-'
      t.string 'Vmii3s-'

      t.string 'Vmip1p-'
      t.string 'Vmip1s-'
      t.string 'Vmip2p-'
      t.string 'Vmip2s-'
      t.string 'Vmip3p-'
      t.string 'Vmip3s-'

      t.string 'Vmis1p-'
      t.string 'Vmis1s-'
      t.string 'Vmis2p-'
      t.string 'Vmis2s-'
      t.string 'Vmis3p-'
      t.string 'Vmis3s-'

      t.string 'Vmmp1p-'
      t.string 'Vmmp2p-'
      t.string 'Vmmp2s-'

      t.string 'Vmsi1p-'
      t.string 'Vmsi1s-'
      t.string 'Vmsi2p-'
      t.string 'Vmsi2s-'
      t.string 'Vmsi3p-'
      t.string 'Vmsi3s-'

      t.string 'Vmsp1p-'
      t.string 'Vmsp1s-'
      t.string 'Vmsp2p-'
      t.string 'Vmsp2s-'
      t.string 'Vmsp3p-'
      t.string 'Vmsp3s-'

    end
  end
end
