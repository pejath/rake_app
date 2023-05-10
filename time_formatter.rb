# frozen_string_literal: true

class TimeFormatter
  attr_reader :time_format, :uncorrect_formats

  FORMATS = {
    'year' => '%Y-', 'month' => '%m-', 'day' => '%d-',
    'hour' => '%H:', 'minute' => '%M:', 'second' => '%S:'
  }.freeze

  def initialize(params)
    @format = params['format']
    @time_format = []
    @incorrect_formats = []
  end

  def call
    set_time_output(@format.split(','))
    if valid?
      Time.now.strftime(@time_format.join)
    else
      "Unknown time format #{@incorrect_formats}"
    end
  end

  def valid?
    @incorrect_formats.empty?
  end

  private

  def set_time_output(params)
    params.each do |format|
      if FORMATS[format]
        @time_format << FORMATS[format]
      else
        @incorrect_formats << format
      end
    end
  end
end
