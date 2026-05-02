defmodule InventarioApp.ArchivoJSON do
  @archivo "productos.json"

  # ================= CARGAR =================
  def cargar do
    case File.read(@archivo) do
      {:ok, contenido} ->
        case Jason.decode(contenido) do
          {:ok, lista} ->
            mapa =
              Enum.reduce(lista, %{}, fn prod, acc ->
                producto = %InventarioApp.Producto{
                  codigo: prod["codigo"],
                  nombre: prod["nombre"],
                  precio: prod["precio"],
                  cantidad: prod["cantidad"]
                }

                Map.put(acc, producto.codigo, producto)
              end)

            {:ok, mapa}

          {:error, _} ->
            {:error, "Error al leer JSON"}
        end

      {:error, :enoent} ->
        File.write(@archivo, "[]")
        {:ok, %{}}

      {:error, _} ->
        {:error, "Error al abrir archivo"}
    end
  end

  # ================= GUARDAR =================
  def guardar(mapa) do
    lista =
      mapa
      |> Map.values()
      |> Enum.map(fn p ->
        %{
          codigo: p.codigo,
          nombre: p.nombre,
          precio: p.precio,
          cantidad: p.cantidad
        }
      end)

    case Jason.encode(lista, pretty: true) do
      {:ok, json} ->
        case File.write(@archivo, json) do
          :ok -> {:ok, "Guardado correctamente"}
          {:error, _} -> {:error, "Error al escribir archivo"}
        end

      {:error, _} ->
        {:error, "Error al convertir a JSON"}
    end
  end
end
