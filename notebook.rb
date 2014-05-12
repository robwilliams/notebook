require 'action_dispatch'
require 'active_record'
require 'sqlite3'
require 'uri'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'notebook.sqlite3')

class Note < ActiveRecord::Base
end

router = ActionDispatch::Routing::RouteSet.new

router.draw do
  get '/show-notes', to: -> env {
    Rack::Response.new do |response|
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
    end
  }

  post '/create-note', to: -> env {
    request = Rack::Request.new(env)

    Rack::Response.new do |response|
      Note.create(content: request.params['content'])

      response.redirect('/show-notes', 303) # See other
    end
  }

  get '*path', to: -> env {
    request = Rack::Request.new(env)

    Rack::Response.new do |response|
      response.write "request_method: #{request.method},"\
                     "request_path: #{request.path}"
    end
  }
end

Notebook = router
