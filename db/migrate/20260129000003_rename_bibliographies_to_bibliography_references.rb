class RenameBibliographiesToBibliographyReferences < ActiveRecord::Migration[8.1]
  def change
    rename_table :bibliographies, :bibliography_references
  end
end
