defmodule Dictionary do

  def word_list do 
    words = File.read!("assets/words.txt")
    String.split(words, ~r/\n/, trim: true)
  end

  def random_word do 
    word_list()
    |> Enum.random
  end
end
