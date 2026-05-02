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
    IO.puts("2. Eliminar socio")
    IO.puts("3. Inscribir clase")
    IO.puts("4. Desinscribir clase")
    IO.puts("5. Buscar socio")
    IO.puts("6. Listar socios")
    IO.puts("7. Socios por clase")
    IO.puts("8. Clases de socio")
    IO.puts("9. Salir")

    opcion = IO.gets("Seleccione: ") |> String.trim()

    case opcion do
      "1" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        nombre = IO.gets("Nombre: ") |> String.trim()
        edad = IO.gets("Edad: ") |> String.trim() |> String.to_integer()

        case Gimnasio.agregar_socio(socios, cedula, nombre, edad) do
          {:ok, nuevos} ->
            IO.puts("Socio creado")
            loop(nuevos)

          {:error, e} ->
            IO.inspect(e)
            loop(socios)
        end

      "2" ->
        cedula = IO.gets("Cédula: ") |> String.trim()

        case Gimnasio.eliminar_socio(socios, cedula) do
          {:ok, nuevos} ->
            IO.puts("Eliminado")
            loop(nuevos)

          {:error, e} ->
            IO.inspect(e)
            loop(socios)
        end

      "3" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        clase = IO.gets("Clase: ") |> String.trim()

        case Gimnasio.inscribir_clase(socios, cedula, clase) do
          {:ok, nuevos} ->
            IO.puts("Inscrito")
            loop(nuevos)

          {:error, e} ->
            IO.inspect(e)
            loop(socios)
        end

      "4" ->
        cedula = IO.gets("Cédula: ") |> String.trim()
        clase = IO.gets("Clase: ") |> String.trim()

        case Gimnasio.desinscribir_clase(socios, cedula, clase) do
          {:ok, nuevos} ->
            IO.puts("Desinscrito")
            loop(nuevos)

          {:error, e} ->
            IO.inspect(e)
            loop(socios)
        end

      "5" ->
        cedula = IO.gets("Cédula: ") |> String.trim()

        case Gimnasio.obtener_socio(socios, cedula) do
          {:ok, socio} -> IO.inspect(socio)
          {:error, e} -> IO.inspect(e)
        end

        loop(socios)

      "6" ->
        {:ok, lista} = Gimnasio.listar_socios(socios)
        IO.inspect(lista)
        loop(socios)

      "7" ->
        clase = IO.gets("Clase: ") |> String.trim()

        {:ok, lista} = Gimnasio.socios_por_clase(socios, clase)
        IO.inspect(lista)
        loop(socios)

      "8" ->
        cedula = IO.gets("Cédula: ") |> String.trim()

        case Gimnasio.clases_de_socio(socios, cedula) do
          {:ok, clases} -> IO.inspect(clases)
          {:error, e} -> IO.inspect(e)
        end

        loop(socios)

      "9" ->
        IO.puts("Salir")

      _ ->
        IO.puts("Opción inválida")
        loop(socios)
    end
  end
end
