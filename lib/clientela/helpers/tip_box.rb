module Clientela
  module Helpers
    class TipBox
      include ActionView::Helpers::TagHelper

      def initialize(args)
        @body = args[:body]
        @header = args[:header]        
      end

      def to_s
        content_tag(:div, content, :class => "tip-box")
      end
      
      private
      def content
        header + @body
      end
      
      def header
        content_tag(:h1, @header)
      end
    end
  end
end