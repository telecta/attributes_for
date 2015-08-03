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

      def attr(attribute_name, options = {})
        content(attribute_name, options)
      end

      private

      def content(attribute_name, options = {}, &block)
        if can_read = options[:can_read]
          return '' unless can? :read, can_read
        end

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
        return " " if options[:label] === false
        " #{human_name(attribute)}: ".html_safe
      end

      def human_name(attribute)
        object.class.human_attribute_name(attribute)
      end

    end
  end
end
