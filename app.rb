# frozen_string_literal: true

require_relative 'time_formatter'
require 'pry'

class App
  def initialize
    @response = Rack::Response.new
  end

  def call(env)
    request = Rack::Request.new(env)
    time_response(request.params)
  end

  private

  def time_response(params)
    rack_response(TimeFormatter.new(params).call)
  end

  def rack_response(body)
    @response.status = 400 if body.match?(/Unknown/i)
    @response.write body.sub(/-$|:$/, '')
    @response.finish
  end
end
