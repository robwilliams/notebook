require 'action_controller'
require 'action_dispatch'
require 'active_record'
require 'sqlite3'
require 'uri'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'notebook.sqlite3')

class Note < ActiveRecord::Base
end

class NotesController < ActionController::Base

  def index
    response_body = "<ul>"

    Note.all.each do |note|
      response_body << "<li>#{note.content}</li>"
    end

    response_body << "</ul>"

    response_body << %q{
      <form action="/create-note" method="post">

        <input name="content" maxlength="140">
        <input type="submit">
      </form>
    }

    render html: response_body.html_safe
  end

  def create
    Note.create(content: request.params['content'])

    redirect_to('/show-notes', status: 303) # See other
  end
end

router = ActionDispatch::Routing::RouteSet.new

router.draw do
  get '/show-notes', to: "notes#index"
  post '/create-note', to: "notes#create"
end

Notebook = router
