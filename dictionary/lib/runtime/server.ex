defmodule Dictionary.Runtime.Server do

  alias Dictionary.Impl.Wordlist

  def start_link() do
    Agent.start_link(&Wordlist.word_list/0)
  end

  def random(_word = pid) do
    Agent.get(pid, &Wordlist.random_word/1)
  end
end
