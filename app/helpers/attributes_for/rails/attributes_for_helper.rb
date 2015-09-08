module AttributesFor
  module Rails
    module AttributesForHelper

      def attributes_for(object, options = {}, &block)
        capture AttributeBuilder.new(object, self), &block
      end

      class AttributeBuilder
        include ActionView::Helpers

        attr_accessor :object, :template

        def initialize(object, template)
          @object, @template = object, template
        end

        def string(label, options = {}, &block)
          wrap_content(" #{label}: " + template.capture(&block), options)
        end

        def method_missing(m, *args, &block)
          build_content(m, *args, &block)
        end

        private

        def build_content(method, attribute_name, options = {}, &block)
          value = object.public_send(attribute_name)

          content = if block_given?
            template.capture(&block)
          elsif value.to_s.empty?
            I18n.t "attributes_for.not_set"
          else
            case method.to_sym
            when :boolean
              I18n.t("attributes_for.#{value.to_s}")
            when :date
              I18n.l(value, format: options[:format])
            when :duration
              ChronicDuration.output(value, :keep_zero => true)
            when :email
              mail_to(value, value, title: human_name(attribute_name))
            when :phone
              phone_number = Phony.format(Phony.normalize(value.to_s), format: :international)
              link_to(phone_number, "tel:#{phone_number}", title: human_name(attribute_name))
            when :url
              link_to(value, value, title: human_name(attribute_name))
            else
              value
            end
          end

          options[:class] ||= icon_map(method)
          options[:id]    ||= attribute_name.to_s

          wrap_content(label(attribute_name, options) + content, options)
        end

        def wrap_content(content, options = {})
          content_tag(:i, content, id: options[:id], class: options[:class])
        end

        def label(attribute, options)
          return " ".html_safe if options[:label] === false
          " #{human_name(attribute)}: ".html_safe
        end

        def human_name(attribute)
          object.class.human_attribute_name(attribute)
        end

        def icon_map(method)
          {
            boolean:  'fa fa-check',
            date:     'fa fa-calendar',
            duration: 'fa fa-clock-o',
            email:    'fa fa-envelope',
            phone:    'fa fa-phone',
            url:      'fa fa-globe',
          }[method]
        end

      end
    end
  end
end
