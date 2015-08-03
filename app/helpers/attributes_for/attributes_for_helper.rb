module AttributesFor
  module AttributesForHelper

    def attributes_for(object, options = {}, &block)
      builder = AttributeBuilder.new(object, current_user)
      capture builder, &block
    end

    class AttributeBuilder
      include ActionView::Helpers
      include CanCan::Ability

      attr_accessor :object, :current_user, :output_buffer

      def initialize(object, current_user)
        @object, @current_user = object, current_user
      end

      def phone(attribute_name, options = {})
        options[:class] = options[:class] || 'fa fa-phone'

        content(attribute_name, options) do |value|
          link_to(" #{number_to_phone(value)}", "tel:#{value}", title: human_name(attribute_name))
        end
      end

      def email(attribute_name, options = {})
        options[:class] = options[:class] || 'fa fa-envelope'

        content(attribute_name, options) do |value|
          mail_to(" #{value}", value, title: human_name(attribute_name))
        end
      end

      def url(attribute_name, options = {})
        options[:class] = options[:class] || 'fa fa-globe'

        content(attribute_name, options) do |value|
          link_to(" #{value}", value, title: human_name(attribute_name))
        end
      end

      def date(attribute_name, options = {})
        options[:class] = options[:class] || 'fa fa-clock-o'

        content(attribute_name, options) do |value|
          I18n.l(value, format: options[:format])
        end
      end

      def string(content, options = {})
        wrap_label_and_content(nil, content, options)
      end

      def attr(attribute_name, options = {})
        content(attribute_name, options)
      end

      private

      def content(attribute_name, options = {}, &block)
        if can_read = options[:can_read]
          return '' unless can? :read, can_read
        end

        value = if attribute_name.is_a?(String)
          attribute
        else
          object.public_send(attribute_name)
        end

        content = if !value.present?
          I18n.t(:not_set)
        elsif block_given?
          yield value
        else
          value
        end

        wrap_label_and_content(attribute_name, content, options)
      end

      def id(attribute, options)
        (options[:id] || attribute).to_s
      end

      def wrap_label_and_content(attribute, content, options = {})
        content_tag(:i, id: id(attribute, options), class: options[:class]) do
          label(attribute, options) + content
        end
      end

      def label(attribute, options)
        return " " if options[:label] === false
        " #{human_name(attribute)}: ".html_safe
      end

      def human_name(attribute)
        object.class.human_attribute_name(attribute)
      end

    end
  end
end
