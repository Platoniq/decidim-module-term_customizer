# frozen_string_literal: true

module Decidim
  module TermCustomizer
    class Translation < TermCustomizer::ApplicationRecord
      self.table_name = "decidim_term_customizer_translations"

      belongs_to :translation_set, class_name: "Decidim::TermCustomizer::TranslationSet"
      has_many :constraints, through: :translation_set

      validates :locale, presence: true
      validates :key, presence: true
      validates :key, format: { with: %r{\A([a-z0-9_/?-]+\.)*[a-z0-9_/?-]+\z} }, unless: -> { key.blank? }
      validates :key, uniqueness: { scope: [:translation_set, :locale] }, unless: -> { key.blank? }

      class << self
        def available_locales
          return I18n.backend.backends.first.available_locales if ENV["RAILS_GROUPS"] == "assets" || ENV["SKIP_DB_CHECK"] == "true"
          select("DISTINCT locale").pluck(:locale).map(&:to_sym)
        rescue ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished
          I18n.backend.backends.first.available_locales
        end
      end
    end
  end
end