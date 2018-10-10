# frozen_string_literal: true

module DeviseTokenAuth::Concerns::ResourceFinder
  extend ActiveSupport::Concern
  include DeviseTokenAuth::Controllers::Helpers

  def get_case_insensitive_field_from_resource_params(field)
    # honor Devise configuration for case_insensitive keys
    q_value = resource_params[field.to_sym]

    if resource_klass.case_insensitive_keys.include?(field.to_sym)
      q_value.downcase!
    end

    if resource_klass.strip_whitespace_keys.include?(field.to_sym)
      q_value.strip!
    end

    q_value
  end

  def find_resource(warden_conditions)
    @resource = resource_klass.find_for_database_authentication(warden_conditions)
  end

  def resource_klass(m = nil)
    if m
      mapping = Devise.mappings[m]
    else
      mapping = Devise.mappings[resource_name] || Devise.mappings.values.first
    end

    mapping.to
  end

  def provider
    DeviseTokenAuth.provider
  end
end
