defmodule Dictionary do

  alias Dictionary.Impl.Wordlist

  # opaque type to that the public will not know how dictionary
  # represented
  @opaque t :: WordList

  # start will start with the word_list function
  @spec start() :: t
  defdelegate start, to: Wordlist, as: :word_list

  @spec random_word(t) :: String.t
  defdelegate random_word(word_list), to: Wordlist
  


end
