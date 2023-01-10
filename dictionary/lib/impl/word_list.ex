defmodule Dictionary.Impl.Wordlist do


  #defines the type that is returned by word_list
  @type t :: list(String)
  
  #world_list() list(String)
  @spec word_list() :: t
  def word_list do
    "assets/words.txt" #created an assets directory in our project and download words.txt into it
      |> File.read!()
      |> String.split(~r/\n/, trim: true)
  end

  # random word expected to be in string
  @spec random_word(t) :: String.t
  def random_word(word_list) do 
    word_list
    |> Enum.random
  end
end
