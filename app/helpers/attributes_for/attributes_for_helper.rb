module AttributesFor
  module AttributesForHelper

    def attributes_for(object, options = {}, &block)
      builder = AttributeBuilder.new(object)
      capture builder, &block
    end

    class AttributeBuilder
      include ActionView::Helpers

      attr_accessor :object, :output_buffer

      def initialize(object)
        @object = object
      end

      def phone(attribute_name, options = {})
        options[:class] ||= 'fa fa-phone'

        content(attribute_name, options) do |value|
          link_to(" #{number_to_phone(value)}", "tel:#{value}", title: human_name(attribute_name))
        end
      end

      def email(attribute_name, options = {})
        options[:class] ||= 'fa fa-envelope'

        content(attribute_name, options) do |value|
          mail_to(" #{value}", value, title: human_name(attribute_name))
        end
      end

      def url(attribute_name, options = {})
        options[:class] ||= 'fa fa-globe'

        content(attribute_name, options) do |value|
          link_to(" #{value}", value, title: human_name(attribute_name))
        end
      end

      def date(attribute_name, options = {})
        options[:class] ||= 'fa fa-clock-o'

        content(attribute_name, options) do |value|
          I18n.l(value, format: options[:format])
        end
      end

      def string(content, options = {})
        wrap_content(" #{content}", options)
      end

      def attribute(attribute_name, options = {})
        content(attribute_name, options)
      end

      private

      def content(attribute_name, options = {}, &block)
        options[:id] ||= attribute_name.to_s

        wrap_content(
          label(attribute_name, options) + prepare_value(attribute_value(attribute_name), &block),
          options
        )
      end

      def prepare_value(value, &block)
        if !value.present?
          I18n.t(:not_set)
        elsif block_given?
          yield value
        else
          value
        end
      end

      def wrap_content(content, options = {})
        content_tag(:i, content, id: options[:id], class: options[:class])
      end

      def attribute_value(attribute_name)
        if attribute_name.is_a?(String)
          attribute_name
        else
          object.public_send(attribute_name)
        end
      end

      def label(attribute, options)
        return " ".html_safe if options[:label] === false
        " #{human_name(attribute)}: ".html_safe
      end

      def human_name(attribute)
        object.class.human_attribute_name(attribute)
      end

    end
  end
end
