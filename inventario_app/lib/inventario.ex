defmodule Inventario do

  # ================= CRUD =================

  def agregar(mapa, codigo, nombre, precio, cantidad) do
    if Map.has_key?(mapa, codigo) do
      {:error, "Código ya existe"}
    else
      case Producto.crear(codigo, nombre, precio, cantidad) do
        {:ok, producto} ->
          nuevo = Map.put(mapa, codigo, producto)
          ArchivoJSON.guardar(nuevo)
          {:ok, nuevo}

        error -> error
      end
    end
  end

  def eliminar(mapa, codigo) do
    if Map.has_key?(mapa, codigo) do
      nuevo = Map.delete(mapa, codigo)
      ArchivoJSON.guardar(nuevo)
      {:ok, nuevo}
    else
      {:error, "Producto no encontrado"}
    end
  end

  def actualizar(mapa, codigo, nombre, precio, cantidad) do
    if Map.has_key?(mapa, codigo) do
      case Producto.crear(codigo, nombre, precio, cantidad) do
        {:ok, producto} ->
          nuevo = Map.put(mapa, codigo, producto)
          ArchivoJSON.guardar(nuevo)
          {:ok, nuevo}

        error -> error
      end
    else
      {:error, "Producto no existe"}
    end
  end

  def listar(mapa) do
    {:ok, Map.values(mapa)}
  end

  # ================= CONSULTAS =================

  # 1. Dos vocales
  def dos_vocales(mapa) do
    lista =
      mapa
      |> Map.values()
      |> Enum.filter(fn p ->
        contar_vocales(p.nombre) >= 2
      end)
      |> Enum.map(fn p -> {p.codigo, p.nombre} end)

    {:ok, lista}
  end

  defp contar_vocales(nombre) do
    nombre
    |> String.downcase()
    |> String.graphemes()
    |> Enum.count(&(&1 in ["a","e","i","o","u"]))
  end

  # 2. Mismo inicio y fin
  def mismo_inicio_fin(mapa) do
    lista =
      mapa
      |> Map.values()
      |> Enum.filter(fn p ->
        n = String.downcase(p.nombre)
        String.first(n) == String.last(n)
      end)

    {:ok, lista}
  end

  # 3. Precio menor
  def precio_menor(mapa, valor) do
    lista =
      mapa
      |> Map.values()
      |> Enum.filter(fn p -> p.precio < valor end)

    {:ok, lista}
  end

  # 4. Top 3 más caros
  def top3(mapa) do
    lista =
      mapa
      |> Map.values()
      |> Enum.sort_by(& &1.precio, :desc)
      |> Enum.take(3)

    {:ok, lista}
  end

  # 5. Entre valores (string)
  def entre(mapa, min, max) do
    texto =
      mapa
      |> Map.values()
      |> Enum.filter(fn p -> p.precio >= min and p.precio <= max end)
      |> Enum.map(fn p -> "#{p.nombre} - #{p.precio}" end)
      |> Enum.join(", ")

    {:ok, texto}
  end

  # 6. Agrupar por rango
  def agrupar(mapa) do
    grupos =
      Enum.group_by(Map.values(mapa), fn p ->
        cond do
          p.precio < 50000 -> "Menores a 50000"
          p.precio <= 100000 -> "Entre 50000 y 100000"
          true -> "Mayores a 100000"
        end
      end)

    {:ok, grupos}
  end
end
