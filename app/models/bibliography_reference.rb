class BibliographyReference < ApplicationRecord
  has_many :reading_lists, dependent: :destroy
  has_many :users, through: :reading_lists

  validates :citation, presence: true, uniqueness: true
  validates :url, presence: true
  validates :title, presence: true
end
