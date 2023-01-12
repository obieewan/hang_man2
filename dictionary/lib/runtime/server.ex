defmodule Dictionary.Runtime.Server do

  #this the type of the runtime server
  @type t :: pid()
  alias Dictionary.Impl.Wordlist

  def start_link() do
    Agent.start_link(&Wordlist.word_list/0)
  end

  def random_word(_word = pid) do
    Agent.get(pid, &Wordlist.random_word/1)
  end
end
