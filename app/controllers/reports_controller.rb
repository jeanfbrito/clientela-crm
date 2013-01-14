class ReportsController < ApplicationController
  def index
    @year = (params[:date][:year].to_i rescue Time.now.year)
  end

  helper_method :quantitative_chart, :qualitative_chart
  private 
  def quantitative_chart
    data_table, max_data = new_data_table(Deal.quantitative_data(@year, current_account.goal_quantitative))
    chart_options = default_chart_options.merge({
      :hAxis => {
        :viewWindowMode => 'explicit',
        :viewWindow => {:max => max_data, :min => 0}
      }
    })
    GoogleVisualr::Interactive::BarChart.new(data_table, chart_options)
  end

  def qualitative_chart
    data_table, max_data = new_data_table(Deal.qualitative_data(@year, current_account.goal_qualitative))
    chart_options = default_chart_options.merge({
      :hAxis => {
        :format => "R$ #,###",
        :viewWindowMode => 'explicit',
        :viewWindow => {:max => max_data, :min => 0}
      }
    })

    formatter = GoogleVisualr::NumberFormat.new({:prefix => "R$ "})
    formatter.columns(1,2,3)
    data_table.format(formatter)

    GoogleVisualr::Interactive::BarChart.new(data_table, chart_options)
  end

  def max(data)
    value = (data.map {|d| d[1,3].max}.max)
    (value.zero?)? 1 : value
  end

  def new_data_table(data)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Month' )
    data_table.new_column('number', 'Total')
    data_table.new_column('number', 'Ganhas')
    data_table.new_column('number', 'Meta')
    data_table.add_rows(data)
    [data_table, (max(data) rescue 0)]
  end

  def default_chart_options
    {
      :backgroundColor => 'transparent',
      :chartArea => { :height => "330" },
      :width => '$("#deal-status").width()', :height => 400,
      :colors => ['#7DD','#B3DDAC'],
      :series => {2 => {:type => 'line', :color => 'black', :lineWidth => 3, :visibleInLegend => false}}
    }
  end
end
