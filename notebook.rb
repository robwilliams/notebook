require 'active_record'
require 'sqlite3'
require 'uri'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'notebook.sqlite3')

class Note < ActiveRecord::Base
end

Notebook = -> env do
  request = Rack::Request.new(env)
  request_method, request_path = env['REQUEST_METHOD'], env['REQUEST_PATH']

  Rack::Response.new do |response|

    if request.get? && request.path == '/show-notes'
      response['Content-Type'] = 'text/html'
      response.write "<ul>"

      Note.all.each do |note|
        response.write "<li>#{note.content}</li>"
      end

      response.write "</ul>"

      response.write %q{
      <form action="/create-note" method="post">

        <input name="content" maxlength="140">
        <input type="submit">
      </form>
      }
    elsif request.post? && request.path == "/create-note"
      Note.create(content: request.params['content'])

      response.redirect('/show-notes', 303) # See other
    else
      response.write "request_method: #{request_method},"\
        "request_path: #{request.path}"
    end
  end
end
