defmodule GestionArchivos do
  def cargar_datos do
  case File.read("socios.csv") do
    {:ok, contenido} ->
      contenido
      |> CsvParser.parse_string()
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
  filas =
    socios
    |> Enum.map(fn {cedula, socio} ->
      [cedula, socio.nombre, socio.edad, Enum.join(socio.clases, ";")]
    end)

  contenido = CsvParser.dump_to_iodata(filas)

  case File.write("socios.csv", contenido) do
  :ok -> :ok
  {:error, _} -> {:error, :no_se_pudo_guardar}
  end
end
end
