defmodule TextClient do

  #API of Text Client
  @spec start() :: :ok
  defdelegate start(), to: TextClient.Impl.Player

end
