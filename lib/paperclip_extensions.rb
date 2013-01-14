module Paperclip
  module ClassMethods
    def validates_attachment_size name, options = {}
      min = options[:greater_than] || (options[:in] && options[:in].first) || 0
      max = options[:less_than] || (options[:in] && options[:in].last) || (1.0/0)
      range = (min..max)
      message = options[:message] || "file size must be between :min and :max bytes."
      message = message.gsub(/:min/, min.to_s).gsub(/:max/, max.to_s) if message.is_a?(String)

      validates_inclusion_of :"#{name}_file_size",
                             :in => range,
                             :message => message,
                             :if => options[:if],
                             :unless => options[:unless],
                             :allow_nil => true
    end
  end
end