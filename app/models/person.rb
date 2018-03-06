class Person < ApplicationRecord
  translates :full_name, :text, :slug

  extend FriendlyId

  friendly_id :full_name, use: :globalize

  globalize_accessors locales: [:it, :en],
    attributes: [:full_name, :text, :slug]
  globalize_validations locales: [:it, :en]

  has_attached_file :avatar

  validates_attachment :avatar,
    content_type: { content_type: /\Aimage\/.*\z/ },
    size: { in: 0..300.kilobytes },
    presence: true

  validates :full_name, presence: true, uniqueness: true
  validates :text, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
  validate :validates_globalized_attributes

  before_validation :normalization_emails

  has_many :articles, dependent: :destroy

  private

  def normalization_emails
    self.emails.reject!(&:blank?)
  end
end
