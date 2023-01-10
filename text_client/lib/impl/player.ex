defmodule TextClient.Impl.Player do


  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  #structure for interact
  @typep state :: { game, tally}


  #start with no parameters
  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({ game, tally})
  end

  
  #created a function loop which shows the current status
  #interact requires game and tally
  # interact take a state
  @spec interact(state) :: :ok
  #don't care with tally as a whole but care with the fields in it
  def interact({_game, _tally = %{ game_state: :won}}) do
    IO.puts("Congratulations. You won!")
  end

  #tally is here because it is use to show the content in letters
  def interact({_game, tally = %{ game_state: :lost }}) do
    IO.puts("Sorry, you lost... the word was #{tally.letters |> Enum.join}")
  end

  def interact({game, tally}) do
    #feedback gonna say good guess or bad guess
    IO.puts feedback_for(tally)
    IO.puts (current_word(tally))
    Hangman.make_move(game, get_guess())
    |> interact
    
  end

  #@type state :: :initializing | :good_guess | :bad_guess | :already_used
  
  #this version of feedback to be called at the very first time we go to interact
  # no need to put this in IO.puts is because it is already inside IO.puts from interact
  def feedback_for(tally = %{ game_state: :initializing}) do
    "Welcome! I'm thing of a #{tally.letters |> length} letter word"
  end

  def feedback_for(_tally = %{ game_state: :good_guess}), do: "Good guess!"
  def feedback_for(_tally = %{ game_state: :bad_guess}), do: "Sorry, that letter's not in the word"
  def feedback_for(_tally = %{ game_state: :already_used}), do: "You already used that letter"

  def current_word(tally) do
    [
      "Word so far: ",
        tally.letters |> Enum.join(" "),
      " turns left: ", 
        tally.turns_left |> to_string,
      " used so far: ",
        tally.used |> Enum.join(","),
    ]
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end



end
