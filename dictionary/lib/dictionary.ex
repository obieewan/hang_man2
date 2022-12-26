defmodule Dictionary do

  def word_list do 
    "assets/words.txt" #created an assets directory in our project and download words.txt into it
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  def random_word do 
    word_list()
    |> Enum.random
  end
end
