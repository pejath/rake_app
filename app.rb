# frozen_string_literal: true

require_relative 'time_formatter'
require 'pry'

class App
  RESPONSE_HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  def initialize
    @response = Rack::Response.new
  end

  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when '/time'
      time_response(request.params)
    else
      not_found_response
    end
  end

  private

  def time_response(params)
    status, body = TimeFormatter.new(params).call
    rack_response(status, body)
  end

  def not_found_response
    rack_response(404, 'Not Found')
  end

  def rack_response(status, body)
    @response.status = status
    @response.write body.sub(/-$|:$/, '')
    @response.headers.merge!(RESPONSE_HEADERS)
    @response.finish
  end
end
