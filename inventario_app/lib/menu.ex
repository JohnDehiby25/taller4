defmodule Menu do

  def iniciar do
    case ArchivoJSON.cargar() do
      {:ok, mapa} ->
        loop(mapa)

      {:error, msg} ->
        IO.puts("Error: #{msg}")
    end
  end

  defp loop(mapa) do
    IO.puts("""

    ===== INVENTARIO =====
    1. Agregar producto
    2. Actualizar producto
    3. Eliminar producto
    4. Listar productos
    5. Productos con 2 vocales
    6. Mismo inicio y fin
    7. Precio menor a valor
    8. Top 3 más caros
    9. Precio entre valores
    10. Agrupar por precio
    0. Salir
    """)

    opcion = IO.gets("Seleccione: ") |> String.trim()

    case opcion do
      "1" -> agregar(mapa)
      "2" -> actualizar(mapa)
      "3" -> eliminar(mapa)
      "4" -> listar(mapa)
      "5" -> dos_vocales(mapa)
      "6" -> mismo_inicio_fin(mapa)
      "7" -> precio_menor(mapa)
      "8" -> top3(mapa)
      "9" -> entre(mapa)
      "10" -> agrupar(mapa)
      "0" -> IO.puts("Adiós 👋")
      _ ->
        IO.puts("Opción inválida")
        loop(mapa)
    end
  end

  # ================= FUNCIONES =================

  defp agregar(mapa) do
    codigo = IO.gets("Código: ") |> String.trim()
    nombre = IO.gets("Nombre: ") |> String.trim()
    precio = IO.gets("Precio: ") |> String.trim() |> String.to_float()
    cantidad = IO.gets("Cantidad: ") |> String.trim() |> String.to_integer()

    case Inventario.agregar(mapa, codigo, nombre, precio, cantidad) do
      {:ok, nuevo} ->
        IO.puts("Producto agregado")
        loop(nuevo)

      {:error, msg} ->
        IO.puts(msg)
        loop(mapa)
    end
  end

  defp actualizar(mapa) do
    codigo = IO.gets("Código: ") |> String.trim()
    nombre = IO.gets("Nuevo nombre: ") |> String.trim()
    precio = IO.gets("Nuevo precio: ") |> String.trim() |> String.to_float()
    cantidad = IO.gets("Nueva cantidad: ") |> String.trim() |> String.to_integer()

    case Inventario.actualizar(mapa, codigo, nombre, precio, cantidad) do
      {:ok, nuevo} ->
        IO.puts("Producto actualizado")
        loop(nuevo)

      {:error, msg} ->
        IO.puts(msg)
        loop(mapa)
    end
  end

  defp eliminar(mapa) do
    codigo = IO.gets("Código a eliminar: ") |> String.trim()

    case Inventario.eliminar(mapa, codigo) do
      {:ok, nuevo} ->
        IO.puts("Producto eliminado")
        loop(nuevo)

      {:error, msg} ->
        IO.puts(msg)
        loop(mapa)
    end
  end

  defp listar(mapa) do
    case Inventario.listar(mapa) do
      {:ok, lista} ->
        Enum.each(lista, fn p ->
          IO.puts("#{p.codigo} - #{p.nombre} - #{p.precio} - #{p.cantidad}")
        end)

      {:error, msg} -> IO.puts(msg)
    end

    loop(mapa)
  end

  defp dos_vocales(mapa) do
    {:ok, lista} = Inventario.dos_vocales(mapa)
    IO.inspect(lista)
    loop(mapa)
  end

  defp mismo_inicio_fin(mapa) do
    {:ok, lista} = Inventario.mismo_inicio_fin(mapa)
    IO.inspect(lista)
    loop(mapa)
  end

  defp precio_menor(mapa) do
    valor = IO.gets("Valor: ") |> String.trim() |> String.to_float()
    {:ok, lista} = Inventario.precio_menor(mapa, valor)
    IO.inspect(lista)
    loop(mapa)
  end

  defp top3(mapa) do
    {:ok, lista} = Inventario.top3(mapa)
    IO.inspect(lista)
    loop(mapa)
  end

  defp entre(mapa) do
    min = IO.gets("Min: ") |> String.trim() |> String.to_float()
    max = IO.gets("Max: ") |> String.trim() |> String.to_float()
    {:ok, texto} = Inventario.entre(mapa, min, max)
    IO.puts(texto)
    loop(mapa)
  end

  defp agrupar(mapa) do
    {:ok, grupos} = Inventario.agrupar(mapa)
    IO.inspect(grupos)
    loop(mapa)
  end
end
