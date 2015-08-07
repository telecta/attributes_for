module AttributesFor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy AttributesFor translations"
      source_root File.expand_path('../templates', __FILE__)

      def copy_translations
        copy_file 'attributes_for.en.yml', 'config/locales/attributes_for.en.yml'
      end

      def inject_stylesheets
        in_root do
          {
            "css" => {
              require_string: " *= require attributes_for",
              where: {before: %r{.*require_self}},
            },
            "css.scss" => {
              require_string: "@import \"attributes_for\";",
              where: {after: %r{\A}},
            },
          }.each do |extension, strategy|
            file = "app/assets/stylesheets/application.#{extension}"

            if File.exists?(Rails.root.join(file))
              stylesheet = "attributes_for.#{extension}"
              copy_file stylesheet, "app/assets/stylesheets/#{stylesheet}"
              inject_into_file file, strategy[:require_string] + "\n", strategy[:where]
            end
          end
        end
      end
    end
  end
end
