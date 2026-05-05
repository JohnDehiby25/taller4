defmodule GestionArchivos do
  alias NimbleCSV.RFC4180, as: CSV

  def cargar_datos do
    case File.read("socios.csv") do
      {:ok, contenido} ->
        contenido
        |> CSV.parse_string()
        |> Enum.drop(1)
        |> Enum.reduce(%{}, fn [cedula, nombre, edad, clases_str], acc ->
          clases =
            if clases_str == "" do
              []
            else
              String.split(clases_str, ";")
            end

          socio = %Socio{
            nombre: nombre,
            edad: String.to_integer(edad),
            clases: clases
          }

          Map.put(acc, cedula, socio)
        end)

      {:error, _} ->
        File.write!("socios.csv", "")
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
          socio.edad,
          Enum.join(socio.clases, ";")
        ]
      end)

    contenido =
      (encabezado ++ filas)
      |> CSV.dump_to_iodata()

    case File.write("socios.csv", contenido) do
      :ok -> {:ok, :guardado}
      {:error, _} -> {:error, :no_se_pudo_guardar}
    end
  end
end
