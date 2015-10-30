module AttributesFor
  module Rails
    module AttributesForHelper

      def attributes_for(object, options = {}, &block)
        capture AttributeBuilder.new(object, self, options), &block
      end

      class AttributeBuilder
        include ActionView::Helpers
        include FontAwesome::Rails::IconHelper

        attr_accessor :object, :template, :default_options

        def initialize(object, template, options = {})
          @object = object
          @template = template
          @default_options = options[:defaults] || {}
        end

        def method_missing(method, *args, &block)
          build_content(method, *args, &block)
        end

        def string(label, options = {}, &block)
          wrap_content(label, template.capture(&block), options)
        end

        private

        def build_content(method, attribute_name, options = {}, &block)
          content = format_attribute(method, attribute_name, options, &block)

          options[:icon] ||= icon_map(method)

          wrap_content(human_name(attribute_name), content, options)
        end

        def format_attribute(method, attribute_name, options = {}, &block)
          value = object.public_send(attribute_name)

          if block_given?
            template.capture(&block)
          elsif value.to_s.empty?
            I18n.t "attributes_for.not_set"
          else
            case method.to_sym
            when :boolean
              I18n.t("attributes_for.#{value.to_s}")
            when :date
              I18n.l(value.to_date, format: options[:format])
            when :datetime
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
              value.to_s
            end
          end
        end

        def wrap_content(label, content, options)
          html_options         = options[:html] || {}
          html_options[:id]    = options.delete(:id) if options.key?(:id)
          html_options[:class] = options.delete(:class) if options.key?(:class)

          unless options[:label] === false
            content = content_tag(:span, "#{label}:", apply_html_options(html_options)) + " " + content
          end

          if options[:icon]
            content = fa_icon(options[:icon], text: content)
          end

          content
        end

        def apply_html_options(options)
          default_options.merge(options)
        end

        def human_name(attribute)
          object.class.human_attribute_name(attribute, default: attribute.to_s.titleize)
        end

        def icon_map(method)
          {
            boolean:  'check',
            date:     'calendar',
            datetime:     'calendar',
            duration: 'clock-o',
            email:    'envelope',
            phone:    'phone',
            url:      'globe',
          }[method]
        end

      end
    end
  end
end
