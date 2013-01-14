class DashboardController < ApplicationController
  def show
    @weeks = [(first_week_start_day..first_week_end_day), (last_week_start_day..last_week_end_day)]
    @activities = Activity.latest.paginate(:page => params[:page], :per_page => 5)
  end

  helper_method :first_week_start_day, :last_week_end_day, :previous_date, :next_date, :funnel_chart

  private
  def funnel_chart
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'status')
    data_table.new_column('number', 'Valor')

    data = []
    Deal.statuses.each do |status|
      value = ((Deal.send(status).count.to_f/Deal.count.to_f).round(2))*100
      next if value.zero?
      data << [t("deals.show.statuses.#{status}"), value]
    end
    data_table.add_rows(data)

    chart_options = {
      :backgroundColor => 'transparent',
      :chartArea => { :height => "330" },
      :width => '$("#deal-status").width()', :height => 400,
      :colors => ['#7DD'],
      :series => {0 => {:visibleInLegend => false}},
      :hAxis => {
        :format => "#'%'",
        :viewWindowMode => 'explicit',
        :viewWindow => {:max => (data.map {|d| d[1]}.max), :min => 0}
      }
    }

    formatter = GoogleVisualr::NumberFormat.new({ :suffix => " %" })
    formatter.columns(1)
    data_table.format(formatter)

    @funnel_chart = GoogleVisualr::Interactive::BarChart.new(data_table, chart_options)
  end

  def previous_date
    first_week_start_day - 1.week
  end

  def next_date
    first_week_start_day + 1.week
  end

  def first_week_start_day
    first_week_day.beginning_of_week
  end

  def first_week_end_day
    first_week_day.end_of_week
  end

  def last_week_start_day
    last_week_day.beginning_of_week
  end

  def last_week_end_day
    last_week_day.end_of_week
  end

  def first_week_day
    @first_week_day ||= (Date.parse(params[:date]) rescue Date.today)
  end

  def last_week_day
    @last_week_day ||= first_week_day.next_week
  end
end
