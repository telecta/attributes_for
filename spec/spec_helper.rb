$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'attributes_for'

require "active_model"

Company = Struct.new(:id, :name, :phone, :fax, :email, :website, :created_at) do
  extend ActiveModel::Naming

  def self.human_attribute_name(attribute)
    I18n.t("activerecord.attributes.company.#{attribute}")
  end

end

User = Struct.new(:name, :role)
