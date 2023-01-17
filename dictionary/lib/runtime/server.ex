defmodule Dictionary.Runtime.Server do

  #this the type of the runtime server
  @type t :: pid()
  # named the process from the name of the module
  # @me refered as the name of process
  alias Dictionary.Impl.Wordlist

  @me __MODULE__

  #pid is passed in as current module
  def start_link() do
    Agent.start_link(&Wordlist.word_list/0, @me)
  end

  #pid removed because it is now started with the application starter
  def random_word() do
    Agent.get(@me, &Wordlist.random_word/1)
  end
end
