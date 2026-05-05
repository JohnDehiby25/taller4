defmodule GestionArchivos do
  alias NimbleCSV.RFC4180, as: CSV

  @archivo Path.join(File.cwd!(), "socios.csv")

  def cargar_datos do
    case File.read(@archivo) do
      {:ok, contenido} ->
        contenido
        |> String.trim()
        |> CSV.parse_string(skip_headers: false) 
        |> Enum.reject(fn fila ->
          List.first(fila) == "cedula"
        end)
        |> Enum.filter(fn fila -> length(fila) == 4 end) # Solo filas válidas
        |> Enum.reduce(%{}, fn [cedula, nombre, edad, clases_str], acc ->
          clases =
            if clases_str == "" do
              []
            else
              String.split(clases_str, ";") |> Enum.map(&String.trim/1)
            end

          socio = %Socio{
            nombre: String.trim(nombre),
            edad: String.to_integer(String.trim(edad)),
            clases: clases
          }

          Map.put(acc, String.trim(cedula), socio)
        end)

      {:error, _} ->
        File.write!(@archivo, "cedula,nombre,edad,clases\n")
        %{}
    end
  end

  def guardar_datos(socios) do
    encabezado = [["cedula", "nombre", "edad", "clases"]]

    filas =
      socios
      |> Enum.map(fn {cedula, socio} ->
        [
          cedula,
          socio.nombre,
          Integer.to_string(socio.edad),
          Enum.join(socio.clases, ";")
        ]
      end)

    contenido =
      (encabezado ++ filas)
      |> CSV.dump_to_iodata()

    case File.write(@archivo, contenido) do
      :ok -> {:ok, :guardado}
      {:error, motivo} -> {:error, motivo}
    end
  end
end
