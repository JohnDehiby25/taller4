defmodule Menu do
  use Application
  def start(_type, _args) do
    iniciar()
    {:ok, self()}
  end

  def iniciar do
    socios = GestionArchivos.cargar_datos()
    loop(socios)
  end
  defp loop(socios) do
    IO.puts("\n--- GIMNASIO ---")
    IO.puts("1. Crear socio")
    IO.puts("2. Listar socios")
    IO.puts("3. Inscribir clase")
    IO.puts("4. Salir")

    opcion = IO.gets("Seleccione una opción: ") |> String.trim()

    case opcion do
      "1" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        nombre = IO.gets("Nombre: ") |> String.trim()
        edad = IO.gets("Edad: ") |> String.trim() |> String.to_integer()

        case Gimnasio.agregar_socio(socios, cedula, nombre, edad) do
          {:ok, nuevos} ->
            IO.puts("Socio creado")
            loop(nuevos)

          {:error, motivo} ->
            IO.inspect(motivo)
            loop(socios)
        end

      "2" ->
        {:ok, lista} = Gimnasio.listar_socios(socios)
        IO.inspect(lista)
        loop(socios)

      "3" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        clase = IO.gets("Clase: ") |> String.trim()

        case Gimnasio.inscribir_clase(socios, cedula, clase) do
          {:ok, nuevos} ->
            IO.puts("Clase agregada")
            loop(nuevos)

          {:error, motivo} ->
            IO.inspect(motivo)
            loop(socios)
        end

      "4" ->
        IO.puts("Salir")

      _ ->
        IO.puts("Opción inválida")
        loop(socios)
    end
  end
end
