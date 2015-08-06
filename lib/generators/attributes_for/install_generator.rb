module AttributesFor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy AttributesFor translations"
      source_root File.expand_path('../templates', __FILE__)

      def copy_translations
        copy_file 'attributes_for.en.yml', 'config/locales/attributes_for.en.yml'
      end

      def inject_stylesheets
        file = "app/assets/stylesheets/application.css"

        if File.exists?(Rails.root.join(file))
          inject_into_file file, " *= require attributes_for\n", {before: %r{.*require_self}}
        end
      end
    end
  end
end
