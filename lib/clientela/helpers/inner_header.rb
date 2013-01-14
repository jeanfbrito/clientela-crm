module Clientela
  module Helpers
    class InnerHeader
      include ActionView::Helpers::TagHelper

      def initialize(args)
        @span = args[:span]
        @header = args[:header]
      end
      
      def to_s
        content_tag(:div, header_and_span, :class => :inner_header)
      end
      
      private
      def header_and_span
        "#{header}#{span}".html_safe
      end
      
      def span
        unless @span.blank?
          content_tag(:span, @span.html_safe)
        end
      end
      
      def header
        content_tag(:h1, @header)
      end
    end
  end
end