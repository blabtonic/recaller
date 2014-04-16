#!/usr/bin/env ruby
require 'sinatra'    #gathers gems
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db") #this is use to create a database called recall.db

class Note
  include DataMapper::Resource #calls the datamapper gem then creates the property of the page 
  property :id, Serial
  property :content,Text, :required => true 
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime 
  property :updated_at, DateTime 
end

DataMapper.finalize.auto_upgrade! #automatically update the database


get "/" do
  @note = Note.all :order => :id.desc
  @title = "All Notes" #title variable 
  erb :home #pulls off of home.erb
end


=begin
  #adds notes to the database 
  the new note is then saved, and the user redirected back to the homepage 
  where the new note will be displayed.
=end
post '/' do
  n = Note.new
  n.content = params[:content]
  n.created_at = Time.now
  n.updated_at = Time.now
  n.save
  redirect '/'
end


get '/:id' do #this is created because of [edit] in home.erb  
  @note = Note.get params[:id]
  @title = "Edit note ##{params[:id]}"
  erb :edit #pulls off of edit.erb
end

put '/:id' do #create /put route 
 n = Note.get params[:id]
 n.content = params[:content]
 n.complete = params[:complete] ? 1 : 0 #once checkmarked complete else no value
 n.updated_at = Time.now
 n.save 
 redirect '/'
end

get '/:id/delete' do
  @note = Note.get params[:id]
  @title = "Confirm deletion of note ##{params[:id]}"
  erb :delete #pulls off of delete.erb
end

delete '/:id' do #pretty much destroy note
  n = Note.get params[:id]
  n.destroy
  redirect '/'
end

get '/:id/complete' do
  n = Note.get params[:id]
  n.complete = n.complete ? 1 : 0 
  n.updated_at = Time.now
  n.save
  redirect '/'
end
