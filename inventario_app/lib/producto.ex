defmodule InventarioApp.Producto do
  defstruct codigo: "", nombre: "", precio: 0.0, cantidad: 0

  # Crear producto con validaciones
  def crear(codigo, nombre, precio, cantidad) do
    with :ok <- validar_codigo(codigo),
         :ok <- validar_nombre(nombre),
         :ok <- validar_precio(precio),
         :ok <- validar_cantidad(cantidad) do
      {:ok, %InventarioApp.Producto{
        codigo: codigo,
        nombre: nombre,
        precio: precio,
        cantidad: cantidad
      }}
    end
  end

  # ================= VALIDACIONES =================

  defp validar_codigo(codigo) do
    cond do
      codigo == "" ->
        {:error, "El código no puede estar vacío"}

      String.length(codigo) > 5 ->
        {:error, "Máximo 5 caracteres"}

      true ->
        :ok
    end
  end

  defp validar_nombre(nombre) do
    cond do
      nombre == "" ->
        {:error, "Nombre vacío"}

      not String.match?(nombre, ~r/^[a-zA-Z\s]+$/) ->
        {:error, "Solo letras"}

      true ->
        :ok
    end
  end

  defp validar_precio(precio) do
    if precio < 0 do
      {:error, "Precio inválido"}
    else
      :ok
    end
  end

  defp validar_cantidad(cantidad) do
    cond do
      not is_integer(cantidad) ->
        {:error, "Debe ser entero"}

      cantidad < 0 ->
        {:error, "Cantidad inválida"}

      true ->
        :ok
    end
  end
end
