class Report
  attr_accessor :report

  def initialize(report)
    @report = report
  end
  
  def data
    raise NotImplementedError
  end
end