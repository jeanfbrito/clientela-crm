module DebugHelper
end

begin
  method :p80
rescue
  def p80(*args)
    p('*' * 80)
    p(*args) unless args.empty?
    p(yield) if block_given?
    p('*' * 80)
    STDOUT.flush
  end
end