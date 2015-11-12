module AttributesFor
  module Rails
    module AttributesForHelper

      def attributes_for(object, options = {}, &block)
        capture AttributeBuilder.new(object, self, options), &block
      end

      class AttributeBuilder
        include ActionView::Helpers
        include FontAwesome::Rails::IconHelper

        attr_accessor :object, :template, :default_options, :wrappers,
          :options

        def initialize(object, template, options = {})
          @object   = object
          @template = template
          @default_options = options[:defaults] || {}

          @wrappers = { label: 'span', value: 'span' }
          @wrappers.merge!(options.delete(:wrappers)) if options.key?(:wrappers)

          @empty    = options.delete(:empty) if options.key?(:empty)
        end

        def method_missing(method, *args, &block)
          build_content(method, *args, &block)
        end

        def string(label, options = {}, &block)
          wrap_content(label, template.capture(&block), options)
        end

        private

        def empty_value
          @empty || I18n.t('attributes_for.not_set')
        end

        def build_value(method, attribute_name, options = {}, &block)
          if block_given?
            template.capture(&block)
          else
            value = object.public_send(attribute_name)
            if value.to_s.empty?
              empty_value
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
          value = build_value(method, attribute_name, options, &block)

          options[:icon] ||= icon_map(method)

          wrap_content(human_name(attribute_name), value, options)
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

        def wrap_content(label, value, options)
          label_html_options = {}
          label_html_options = options.delete(:label_html) if options.key?(:label_html)
          label_html_options[:id] = options.delete(:id) if options.key?(:id)

          value_html_options = {}
          value_html_options = options.delete(:value_html) if options.key?(:value_html)

          content = content_tag(
            wrappers[:value],
            value,
            apply_default_options(:value_html, value_html_options)
          )

          unless options[:label] === false
            content = content_tag(
              wrappers[:label],
              "#{label}:",
              apply_default_options(:label_html, label_html_options)
            ) + ' ' + content
          end

          content = fa_icon(options[:icon], text: content) if options[:icon]
          content
        end

        def apply_default_options(key, options)
          if default_options.key?(key)
            default_options[key].merge(options)
          else
            options
          end
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
