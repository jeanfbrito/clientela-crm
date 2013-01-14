module Clientela
  module Helpers
    class Listing
      include ActionView::Helpers::TagHelper

      def initialize(args)
        @body = args[:body]
      end

      def to_s
        content_tag(:table, tbody, :class => "listing")
      end

      private
      def tbody
        content_tag(:tbody, body)
      end

      def body
        @body
      end
    end
  end
end