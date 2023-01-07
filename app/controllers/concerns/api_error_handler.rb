# frozen_string_literal: true

module ApiErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotUnique do |e|
      json_reponse({ message: e.message }, :conflict)
    end

    rescue_from ResponseError::NotFound do |e|
      json_reponse({ message: e.message }, :not_found)
    end

    rescue_from ResponseError::Conflict do |e|
      json_reponse({ message: e.message }, :conflict)
    end
  end
end
