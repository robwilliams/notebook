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
    Note.create(content: params[:content])

    redirect_to(notes_path, status: :see_other)
  end
end

router = ActionDispatch::Routing::RouteSet.new

router.draw do
  resources :notes, only: [:index, :create]
end

NotesController.send :include, router.url_helpers

Notebook = router
