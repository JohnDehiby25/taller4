defmodule Gimnasio do
  def agregar_socio(socios, cedula, nombre, edad) do
    case Socio.nuevo(nombre, edad) do
      {:ok, socio} ->
        if Map.has_key?(socios, cedula) do
          {:error, :cedula_duplicada}
        else
          nuevos = Map.put(socios, cedula, socio)
          GestionArchivos.guardar_datos(nuevos)
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
        GestionArchivos.guardar_datos(nuevos)
        {:ok, nuevos}
    end
  end

  def eliminar_socio(socios, cedula) do
    if Map.has_key?(socios, cedula) do
      nuevos = Map.delete(socios, cedula)
      GestionArchivos.guardar_datos(nuevos)
      {:ok, nuevos}
    else
      {:error, :no_encontrado}
    end
  end

  def inscribir_clase(socios, cedula, clase) do
    case Map.get(socios, cedula) do
      nil ->
        {:error, :no_encontrado}

      socio ->
        case Socio.inscribir_clase(socio, clase) do
          {:ok, actualizado} ->
            nuevos = Map.put(socios, cedula, actualizado)
            GestionArchivos.guardar_datos(nuevos)
            {:ok, nuevos}

          error -> error
        end
    end
  end

  def desinscribir_clase(socios, cedula, clase) do
    case Map.get(socios, cedula) do
      nil ->
        {:error, :no_encontrado}

      socio ->
        case Socio.desinscribir_clase(socio, clase) do
          {:ok, actualizado} ->
            nuevos = Map.put(socios, cedula, actualizado)
            GestionArchivos.guardar_datos(nuevos)
            {:ok, nuevos}

          error ->
            error
        end
    end
  end

  def obtener_socio(socios, cedula) do
    case Map.get(socios, cedula) do
      nil -> {:error, :no_encontrado}
      socio -> {:ok, socio}
    end
  end

  def socios_por_clase(socios, clase) do
    resultado =
      socios
      |> Map.values()
      |> Enum.filter(fn socio -> Socio.tiene_clase?(socio, clase) end)

    {:ok, resultado}
  end

  def clases_de_socio(socios, cedula) do
    case Map.get(socios, cedula) do
      nil ->
        {:error, :no_encontrado}

      socio ->
        {:ok, socio.clases}
    end
  end
  def listar_socios(socios) do
    {:ok, Map.values(socios)}
  end

end
