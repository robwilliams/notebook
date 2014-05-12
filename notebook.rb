require 'action_controller'
require 'action_dispatch'
require 'active_record'
require 'sqlite3'
require 'uri'

ActionController::Base.append_view_path("views")

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'notebook.sqlite3')

class Note < ActiveRecord::Base
end

class NotesController < ActionController::Base

  def index
    @notes = Note.all
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
