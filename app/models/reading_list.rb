class ReadingList < ApplicationRecord
  belongs_to :bibliography_reference, class_name: "BibliographyReference", foreign_key: :bibliography_id

  validates :user, presence: true
  validates :bibliography_id, presence: true
  validates :user, uniqueness: { scope: :bibliography_id, message: "can only add a bibliography entry once" }
end
