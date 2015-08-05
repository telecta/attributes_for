module AttributesFor
  module AttributesForHelper

    def attributes_for(object, options = {}, &block)
      builder = AttributeBuilder.new(object, self)
      capture builder, &block
    end

    class AttributeBuilder
      include ActionView::Helpers

      attr_accessor :object, :template, :output_buffer

      def initialize(object, template)
        @object, @template = object, template
      end

      def boolean(attribute_name, options = {}, &block)
        options[:class] ||= 'fa fa-check'
        content(attribute_name, __method__, options, &block)
      end

      def phone(attribute_name, options = {}, &block)
        options[:class] ||= 'fa fa-phone'
        content(attribute_name, __method__, options, &block)
      end

      def email(attribute_name, options = {}, &block)
        options[:class] ||= 'fa fa-envelope'
        content(attribute_name, __method__, options, &block)
      end

      def url(attribute_name, options = {}, &block)
        options[:class] ||= 'fa fa-globe'
        content(attribute_name, __method__, options, &block)
      end

      def date(attribute_name, options = {}, &block)
        options[:class] ||= 'fa fa-clock-o'
        content(attribute_name, __method__, options, &block)
      end

      def string(content, options = {})
        wrap_content(" #{content}", options)
      end

      def attribute(attribute_name, options = {}, &block)
        content(attribute_name, __method__, options, &block)
      end

      private

      def content(attribute_name, method, options = {}, &block)
        wrap_content(label(attribute_name, options) + build_content(attribute_name, method, options, &block), options)
      end

      def build_content(attribute_name, method, options = {}, &block)
        return template.capture(&block) if block_given?

        value = attribute_value(attribute_name)

        return I18n.t "attributes_for.not_set" if value.to_s.empty?

        case method.to_sym
        when :attribute
          value
        when :boolean
          I18n.t("attributes_for.#{value.to_s}")
        when :date
          I18n.l(value, format: options[:format])
        when :email
          mail_to(" #{value}", value, title: human_name(attribute_name))
        when :phone
          link_to(" #{number_to_phone(value)}", "tel:#{value}", title: human_name(attribute_name))
        when :url
          link_to(" #{value}", value, title: human_name(attribute_name))
        end
      end

      def content(attribute_name, method, options = {}, &block)
        options[:id] ||= attribute_name.to_s
        wrap_content(label(attribute_name, options) + build_content(attribute_name, method, options, &block), options)
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
