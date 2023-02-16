defmodule Dictionary.Runtime.Server do

  #this the type of the runtime server
  @type t :: pid()
  alias Dictionary.Impl.Wordlist


  #pid is passed in as current module
  def start_link() do
    Agent.start_link(&Wordlist.word_list/0, name: :wilma)
  end

  #pid removed because it is now started with the application starter
  def random_word() do
    Agent.get(:wilma, &Wordlist.random_word/1)
  end
end
