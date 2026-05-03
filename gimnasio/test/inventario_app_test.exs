defmodule InventarioApp.ProductoTest do
  use ExUnit.Case, async: true

  alias InventarioApp.Producto


  describe "crear/4 – casos válidos" do
    test "crea un producto con todos los datos correctos" do
      assert {:ok, p} = Producto.crear("A001", "Leche", 3500, 10)
      assert p.codigo   == "A001"
      assert p.nombre   == "Leche"
      assert p.precio   == 3500
      assert p.cantidad == 10
    end

    test "acepta precio igual a cero" do
      assert {:ok, _} = Producto.crear("B001", "Muestra", 0, 5)
    end

    test "acepta cantidad igual a cero" do
      assert {:ok, _} = Producto.crear("C001", "Pan", 1500, 0)
    end

    test "acepta nombre con espacios" do
      assert {:ok, p} = Producto.crear("D001", "Leche Entera", 4000, 3)
      assert p.nombre == "Leche Entera"
    end

    test "acepta código de exactamente 5 caracteres" do
      assert {:ok, _} = Producto.crear("AB123", "Agua", 800, 20)
    end
  end

  describe "crear/4 – validación de código" do
    test "rechaza código vacío" do
      assert {:error, _} = Producto.crear("", "Arroz", 2000, 1)
    end

    test "rechaza código con más de 5 caracteres" do
      assert {:error, msg} = Producto.crear("ABCDEF", "Arroz", 2000, 1)
      assert msg =~ "5"
    end
  end

  describe "crear/4 – validación de nombre" do
    test "rechaza nombre vacío" do
      assert {:error, _} = Producto.crear("E001", "", 1000, 1)
    end

    test "rechaza nombre con dígitos" do
      assert {:error, _} = Producto.crear("E002", "Arroz2", 1000, 1)
    end

    test "rechaza nombre con caracteres especiales" do
      assert {:error, _} = Producto.crear("E003", "Arroz!", 1000, 1)
    end
  end

  describe "crear/4 – validación de precio" do
    test "rechaza precio negativo" do
      assert {:error, _} = Producto.crear("F001", "Sal", -100, 5)
    end
  end

  describe "crear/4 – validación de cantidad" do
    test "rechaza cantidad negativa" do
      assert {:error, _} = Producto.crear("G001", "Sal", 500, -1)
    end

    test "rechaza cantidad decimal (no entero)" do
      assert {:error, _} = Producto.crear("G002", "Sal", 500, 1.5)
    end
  end
end


defmodule InventarioApp.InventarioTest do
  use ExUnit.Case, async: true

  alias InventarioApp.Inventario
  alias InventarioApp.Producto

  # Construye un mapa de prueba sin tocar el archivo JSON.
  # ArchivoJSON.guardar es llamado por las funciones CRUD pero su
  # valor de retorno es ignorado, por lo que no interrumpe las pruebas.
  defp mapa_base do
    {:ok, p1} = Producto.crear("P001", "Leche",  3500,  10)
    {:ok, p2} = Producto.crear("P002", "Arroz",  8000,   5)
    {:ok, p3} = Producto.crear("P003", "Azucar", 120000, 2)
    {:ok, p4} = Producto.crear("P004", "Agua",   1200,  30)
    {:ok, p5} = Producto.crear("P005", "Sal",    75000,  8)

    %{
      "P001" => p1,
      "P002" => p2,
      "P003" => p3,
      "P004" => p4,
      "P005" => p5
    }
  end


  describe "agregar/5" do
    test "agrega un producto nuevo correctamente" do
      assert {:ok, nuevo_mapa} = Inventario.agregar(%{}, "X001", "Cafe", 5000, 10)
      assert Map.has_key?(nuevo_mapa, "X001")
    end

    test "rechaza código duplicado" do
      mapa = mapa_base()
      assert {:error, _} = Inventario.agregar(mapa, "P001", "Otro", 1000, 1)
    end

    test "rechaza producto con datos inválidos (código largo)" do
      assert {:error, _} = Inventario.agregar(%{}, "TOOLONG", "Cafe", 5000, 10)
    end
  end

  describe "eliminar/2" do
    test "elimina un producto existente" do
      mapa = mapa_base()
      assert {:ok, nuevo_mapa} = Inventario.eliminar(mapa, "P001")
      refute Map.has_key?(nuevo_mapa, "P001")
    end

    test "retorna error si el código no existe" do
      assert {:error, _} = Inventario.eliminar(%{}, "NOEXIST")
    end
  end

  describe "actualizar/5" do
    test "actualiza un producto existente" do
      mapa = mapa_base()
      assert {:ok, nuevo_mapa} = Inventario.actualizar(mapa, "P001", "LecheDesnatada", 4000, 8)
      assert nuevo_mapa["P001"].nombre == "LecheDesnatada"
      assert nuevo_mapa["P001"].precio == 4000
    end

    test "retorna error si el producto no existe" do
      assert {:error, _} = Inventario.actualizar(%{}, "ZZZ", "Nada", 0, 0)
    end
  end

  describe "listar/1" do
    test "devuelve todos los productos del mapa" do
      mapa = mapa_base()
      assert {:ok, lista} = Inventario.listar(mapa)
      assert length(lista) == map_size(mapa)
    end

    test "devuelve lista vacía si el mapa está vacío" do
      assert {:ok, []} = Inventario.listar(%{})
    end
  end


  describe "dos_vocales/1" do
    test "filtra productos con al menos dos vocales en el nombre" do
      mapa = mapa_base()
      assert {:ok, lista} = Inventario.dos_vocales(mapa)
      codigos = Enum.map(lista, fn {cod, _} -> cod end)
      assert "P004" in codigos
      assert "P001" in codigos
      refute "P005" in codigos
    end

    test "retorna lista vacía cuando ningún nombre tiene 2 vocales" do
      {:ok, p} = Producto.crear("T001", "Hbl", 100, 1)
      assert {:ok, []} = Inventario.dos_vocales(%{"T001" => p})
    end
  end

  describe "mismo_inicio_fin/1" do
    test "filtra productos cuyo nombre empieza y termina con la misma letra" do
      {:ok, p1} = Producto.crear("M001", "Anan",  1000, 1)   # a...a ✓
      {:ok, p2} = Producto.crear("M002", "Cafe",  2000, 1)   # c...e ✗
      {:ok, p3} = Producto.crear("M003", "Elixire", 3000, 1) # e...e ✓
      mapa = %{"M001" => p1, "M002" => p2, "M003" => p3}

      assert {:ok, lista} = Inventario.mismo_inicio_fin(mapa)
      codigos = Enum.map(lista, & &1.codigo)
      assert "M001" in codigos
      assert "M003" in codigos
      refute "M002" in codigos
    end
  end

  describe "precio_menor/2" do
    test "filtra productos con precio estrictamente menor al valor dado" do
      mapa = mapa_base()
      assert {:ok, lista} = Inventario.precio_menor(mapa, 5000)
      assert length(lista) == 2
      assert Enum.all?(lista, fn p -> p.precio < 5000 end)
    end

    test "retorna lista vacía si ninguno es más barato" do
      mapa = mapa_base()
      assert {:ok, []} = Inventario.precio_menor(mapa, 0)
    end
  end

  describe "top3/1" do
    test "devuelve los 3 productos más caros en orden descendente" do
      mapa = mapa_base()
      assert {:ok, lista} = Inventario.top3(mapa)
      assert length(lista) == 3
      precios = Enum.map(lista, & &1.precio)
      assert precios == Enum.sort(precios, :desc)
      assert hd(lista).codigo == "P003"
    end

    test "devuelve todos si hay menos de 3 productos" do
      {:ok, p} = Producto.crear("U001", "Solo", 999, 1)
      assert {:ok, lista} = Inventario.top3(%{"U001" => p})
      assert length(lista) == 1
    end
  end

  describe "entre/3" do
    test "retorna string con productos en el rango de precio" do
      mapa = mapa_base()
      assert {:ok, texto} = Inventario.entre(mapa, 5000, 80000)
      assert is_binary(texto)
      assert texto =~ "Sal"
      assert texto =~ "Arroz"
      refute texto =~ "Azucar"   # 120000, fuera del rango
    end

    test "retorna cadena vacía si ningún producto está en el rango" do
      assert {:ok, ""} = Inventario.entre(%{}, 0, 100)
    end
  end

  describe "agrupar/1" do
    test "agrupa los productos en los tres rangos de precio" do
      mapa = mapa_base()
      assert {:ok, grupos} = Inventario.agrupar(mapa)

      menores   = Map.get(grupos, "Menores a 50000", [])
      medios    = Map.get(grupos, "Entre 50000 y 100000", [])
      mayores   = Map.get(grupos, "Mayores a 100000", [])

      assert length(menores) == 3
      assert length(medios) == 1
      assert length(mayores) == 1
    end

    test "maneja mapa vacío sin errores" do
      assert {:ok, grupos} = Inventario.agrupar(%{})
      assert grupos == %{}
    end
  end
end
