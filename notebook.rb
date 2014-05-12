require 'sqlite3'
require 'uri'

database = SQLite3::Database.new('notebook.sqlite3')

Notebook = -> env do
  request = Rack::Request.new(env)
  request_method, request_path = env['REQUEST_METHOD'], env['REQUEST_PATH']

  Rack::Response.new do |response|

    if request.get? && request.path == '/show-notes'
      response['Content-Type'] = 'text/html'
      response.write "<ul>"

      database.execute('SELECT content FROM notes') do |(content)|
        response.write "<li>#{CGI.escapeHTML(content)}</li>"
      end

      response.write "</ul>"

      response.write %q{
      <form action="/create-note" method="post">

        <input name="content" maxlength="140">
        <input type="submit">
      </form>
      }
    elsif request.post? && request.path == "/create-note"
      content = request.params['content']
      database.execute('INSERT INTO notes VALUES (?)', content)

      response.redirect('/show-notes', 303) # See other
    else
      response.write "request_method: #{request_method},"\
        "request_path: #{request.path}"
    end
  end
end
