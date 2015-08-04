module AttributesFor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy AttributesFor translations"
      source_root File.expand_path('../templates', __FILE__)

      def copy_translations
        copy_file 'attributes_for.en.yml', 'config/locales/attributes_for.en.yml'
      end

    end
  end
end
