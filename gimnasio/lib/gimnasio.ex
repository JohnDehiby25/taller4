defmodule Gimnasio do
  def agregar_socio(socios, cedula, nombre, edad) do
    case Socio.nuevo(nombre, edad) do
      {:ok, socio} ->
        if Map.has_key?(socios, cedula) do
          {:error, :cedula_duplicada}
        else
          nuevos = Map.put(socios, cedula, socio)
          guardar_datos(nuevos)
          {:ok, nuevos}
        end

      error -> error
    end
  end

  def actualizar_socio(socios, cedula, nombre, edad) do
    case Map.get(socios, cedula) do
      nil ->
        {:error, :no_encontrado}

      socio ->
        actualizado = %{socio | nombre: nombre, edad: edad}
        nuevos = Map.put(socios, cedula, actualizado)
        guardar_datos(nuevos)
        {:ok, nuevos}
    end
  end

  def eliminar_socio(socios, cedula) do
    if Map.has_key?(socios, cedula) do
      nuevos = Map.delete(socios, cedula)
      guardar_datos(nuevos)
      {:ok, nuevos}
    else
      {:error, :no_encontrado}
    end
  end



end
