defmodule Producto do
  defstruct codigo: "", nombre: "", precio: 0.0, cantidad: 0

  # Crear producto con validaciones
  def crear(codigo, nombre, precio, cantidad) do
    with :ok <- validar_codigo(codigo),
         :ok <- validar_nombre(nombre),
         :ok <- validar_precio(precio),
         :ok <- validar_cantidad(cantidad) do
      {:ok, %Producto{
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
        {:error, "El código debe tener máximo 5 caracteres"}

      true ->
        :ok
    end
  end

  defp validar_nombre(nombre) do
    cond do
      nombre == "" ->
        {:error, "El nombre no puede estar vacío"}

      not String.match?(nombre, ~r/^[a-zA-Z\s]+$/) ->
        {:error, "El nombre solo debe contener letras"}

      true ->
        :ok
    end
  end

  defp validar_precio(precio) do
    cond do
      precio < 0 ->
        {:error, "El precio no puede ser negativo"}

      true ->
        :ok
    end
  end

  defp validar_cantidad(cantidad) do
    cond do
      cantidad < 0 ->
        {:error, "La cantidad no puede ser negativa"}

      not is_integer(cantidad) ->
        {:error, "La cantidad debe ser un número entero"}

      true ->
        :ok
    end
  end
end
