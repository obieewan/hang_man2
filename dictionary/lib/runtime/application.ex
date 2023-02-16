defmodule Dictionary.Runtime.Application do

  #feature behavior Application
  use Application

  #added this module in runtime 
  #this will start the application
  #function start callback
  #takes two arguments
  def start(_type, _args) do
    Dictionary.Runtime.Server.start_link
  end
end

    
