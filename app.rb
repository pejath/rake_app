require_relative 'time_formatter'
require 'pry'

class App

  def call(env)
    @request = Rack::Request.new(env)

    case @request.path_info
    when '/time'
      res_response = TimeFormatter.new(@request.params)

      if res_response.valid?
        rack_response(200, res_response.call)
      else
        rack_response(400, "Unknown time format #{res_response.uncorrect_formats}")
      end
    else
      rack_response(404, 'Not Found')
    end
  end

  private

  def rack_response(status, body)
    response = Rack::Response.new
    response.status = status
    response.write body.sub(/-$|:$/, '')
    response.add_header('Content-Type', 'text/plain')
    response.finish
  end

end
