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
        value = attribute_value(attribute_name)
        options[:class] = options[:class] || 'fa fa-phone'
        attribute(attribute_name,
          link_to(" #{number_to_phone(value)}", "tel:#{value}", title: human_name(attribute_name)),
          options
        )
      end

      def email(attribute_name, options = {})
        value = attribute_value(attribute_name)
        options[:class] = options[:class] || 'fa fa-envelope'
        attribute(attribute_name,
          mail_to(" #{value}", value, title: human_name(attribute_name)),
          options
        )
      end

      def url(attribute_name, options = {})
        value = attribute_value(attribute_name)
        options[:class] = options[:class] || 'fa fa-globe'
        attribute(attribute_name,
          link_to(" #{value}", value, title: human_name(attribute_name)),
          options
        )
      end

      def date(attribute_name, options = {})
        options[:class] = options[:class] || 'fa fa-clock-o'
        attribute(attribute_name,
          I18n.l(attribute_value(attribute_name), format: options[:format]),
          options
        )
      end

      def string(content, options = {})
        attribute(nil, content, options)
      end

      def attr(attribute_name, options = {})
        attribute(attribute_name, attribute_value(attribute_name), options)
      end

      private

      def attribute(attribute_name, content, options = {})
        if can_read = options[:can_read]
          return '' unless can? :read, can_read
        end
        wrap_content(attribute_name, content, options)
      end

      def attribute_value(attribute)
        value = if attribute.is_a?(String)
          attribute
        else
          object.public_send(attribute)
        end
        value.to_s.empty? ? I18n.t(:not_set) : value
      end

      def id(attribute, options)
        (options[:id] || attribute).to_s
      end

      def wrap_content(attribute, content, options = {})
        options = options.dup
        options[:label] = options[:label] === false ? false : true
        content_tag(:i, id: id(attribute, options), class: options[:class]) do
          options[:label] ? " #{human_name(attribute)}: #{content}".html_safe : " #{content}".html_safe
        end
      end

      def human_name(attribute)
        object.class.human_attribute_name(attribute)
      end

    end

  end

end
