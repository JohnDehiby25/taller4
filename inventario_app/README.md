 Sistema de Inventario en Elixir

 Descripción

Este proyecto consiste en la implementación de un sistema de gestión de inventario desarrollado en **Elixir**, el cual permite administrar productos mediante operaciones CRUD (Crear, Leer, Actualizar y Eliminar), así como realizar diversas consultas utilizando programación funcional.

El sistema utiliza estructuras de datos como **Maps** y **Structs**, y permite la persistencia de la información en archivos **JSON** mediante la librería `Jason`.

---

Objetivo

Aplicar los siguientes conceptos:

* Structs
* Mapas (Map)
* Manejo de archivos (JSON)
* Manejo de errores
* Programación funcional con `Enum`
* Interacción por consola

---

 Estructura del Proyecto

El proyecto está organizado en los siguientes módulos:

* **Producto**: Define el struct y contiene las validaciones de los datos.
* **Inventario**: Contiene la lógica del sistema (CRUD y consultas).
* **ArchivoJSON**: Maneja la lectura y escritura del archivo `productos.json`.
* **Menu**: Permite la interacción con el usuario mediante consola.

---

 Funcionalidades

 CRUD

* Agregar producto
* Actualizar producto
* Eliminar producto
* Listar productos

Consultas con Enum

* Productos cuyo nombre contiene al menos dos vocales
* Productos cuyo nombre comienza y termina con la misma letra
* Productos con precio menor a un valor dado
* Los 3 productos más caros
* Productos con precio entre dos valores
* Agrupación de productos por rango de precio

---

 Persistencia

* Archivo utilizado: `productos.json`
* Se cargan los datos al iniciar el programa
* Se guardan automáticamente después de cada operación
* Se crea el archivo si no existe
* Se manejan errores de lectura y escritura

---

 Validaciones

* No se permiten códigos repetidos
* El código debe tener máximo 5 caracteres
* El nombre solo contiene letras
* El precio debe ser mayor o igual a 0
* La cantidad debe ser un entero mayor o igual a 0

---
 Ejecución del Proyecto

1. Clonar el repositorio:

```bash
git clone <URL_DEL_REPOSITORIO>
cd inventario_app
```

2. Instalar dependencias:

```bash
mix deps.get
```

3. Ejecutar el programa:

```bash
iex.bat -S mix
```

4. Iniciar el sistema:

```elixir
InventarioApp.Menu.iniciar()
``




Durante el desarrollo de este proyecto se aprendió:

* Uso de structs y mapas en Elixir
* Manejo de archivos JSON
* Programación funcional con `Enum`
* Manejo de errores de forma estructurada
* Creación de aplicaciones interactivas por consola
* Organización modular de proyectos

---



---
