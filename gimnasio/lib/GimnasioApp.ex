defmodule GimnasioApp do
  use Application

  def start(_type, _args) do
    children = [
      {Task, fn -> Menu.iniciar() end}
    ]

    opts = [strategy: :one_for_one, name: Gimnasio.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
