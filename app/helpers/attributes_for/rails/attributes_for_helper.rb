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

        def build_value(method, attribute_name, options = {}, &block)
          if block_given?
            template.capture(&block)
          else
            value = object.public_send(attribute_name)
            if value.to_s.empty?
              I18n.t 'attributes_for.not_set'
            else
              format_value(
                method,
                value,
                options.reverse_merge(title: human_name(attribute_name))
              )
            end
          end
        end

        def build_content(method, attribute_name, options = {}, &block)
          content = build_value(method, attribute_name, options, &block)

          options[:icon] ||= icon_map(method)

          wrap_content(human_name(attribute_name), content, options)
        end

        def format_value(method, value, options = {})
          case method.to_sym
          when :boolean
            I18n.t("attributes_for.#{value}")
          when :date
            I18n.l(value.to_date, format: options[:format])
          when :datetime
            I18n.l(value, format: options[:format])
          when :duration
            ChronicDuration.output(value, keep_zero: true)
          when :email
            mail_to(value, value, title: options[:title])
          when :phone
            phone_number = Phony.format(Phony.normalize(value.to_s),
                                        format: :international)
            link_to(phone_number, "tel:#{phone_number}", title: options[:title])
          when :url
            link_to(value, value, title: options[:title])
          else
            value.to_s
          end
        end

        def wrap_content(label, content, options)
          html_options         = options[:html] || {}
          html_options[:id]    = options.delete(:id) if options.key?(:id)
          html_options[:class] = options.delete(:class) if options.key?(:class)

          unless options[:label] === false
            content = content_tag(
              :span,
              "#{label}:",
              apply_html_options(html_options)
            ) + ' ' + content
          end

          content = fa_icon(options[:icon], text: content) if options[:icon]
          content
        end

        def apply_html_options(options)
          default_options.merge(options)
        end

        def human_name(attribute)
          object
            .class
            .human_attribute_name(attribute, default: attribute.to_s.titleize)
        end

        def icon_map(method)
          {
            boolean:  'check',
            date:     'calendar',
            datetime: 'calendar',
            duration: 'clock-o',
            email:    'envelope',
            phone:    'phone',
            url:      'globe'
          }[method]
        end
      end
    end
  end
end
