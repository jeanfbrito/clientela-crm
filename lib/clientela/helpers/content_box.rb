module Clientela
  module Helpers
    class ContentBox
      include ActionView::Helpers::TagHelper

      def initialize(args)
        @inner_header = Clientela::Helpers::InnerHeader.new(:header => args[:header], :span => args[:span])
        @body = args[:body]
        @id = args[:id] || :main_content
      end
      
      def to_s
        html = []
        html << @inner_header
        html << content_tag(:div, @body, :id => @id)
        html.join.html_safe
      end
    end
  end
end