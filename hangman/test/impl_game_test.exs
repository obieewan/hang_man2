defmodule HangmanImplGameTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Impl.Game

  test "new game returns structure" do
    game = Game.new_game

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game = Game.new_game("combat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["c", "o", "m", "b", "a", "t"]
    #checks that each element is in lower case
    assert Enum.all?(game.letters, fn codepoint -> String.match?(codepoint, ~r/^[a-z]+$/) end)
  end

  test "state doesn't change if a game is won or lost" do
    #created a loop for :won :lost
    for state <- [:won, :lost] do
    game = Game.new_game("combat")
    #:game_state change to won manually to see if the state changes after another turn or won
    game = Map.put(game, :game_state, :won)
    { new_game, _tally } = Game.make_move(game, "x")
    assert new_game == game
  end

end
