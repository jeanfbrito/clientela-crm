module Clientela
  class Base
    class << self
      def polymorphic_email_dropbox(record)
        "dropbox+#{Account.find_current.domain}+#{record.class.to_s.downcase}+#{record.id}@#{base_url}"
      end

      def url(domain)
        "#{domain}.#{base_url}"
      end

      private
      def base_url
        "clientela.com.br"
      end
    end
  end
end