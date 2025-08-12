# 🐉 Dragon Ball Z - Sistema de Tarjetas 🐉

## 📋 Descripción del Proyecto

Este proyecto presenta un **sistema web temático de Dragon Ball Z** que incluye un formulario de login y una página para mostrar tarjetas de personajes en formato de cards. El frontend está **completamente desarrollado**, pero requiere la **finalización del backend** para ser funcional.

---

## 🎯 Objetivo de la Actividad

**Completar el desarrollo del backend** para lograr un sistema funcional de autenticación y gestión de tarjetas por usuario.

---

## 📁 Estructura del Proyecto

```
ejercicio_login_sesion/
├── 📄 index.html          # Página de login (✅ Completo)
├── 📄 tarjetas.html       # Página de tarjetas (✅ Completo)
├── 📄 style.css           # Estilos Dragon Ball Z (✅ Completo)
├── 📄 tarjetas.js         # JavaScript dinámico (✅ Completo)
├── 📄 conexion.php        # Conexión a base de datos (✅ Completo)
├── 📄 dragonballz.sql     # Base de datos completa (✅ Completo)
└── 📁 api/               # ⚠️ CARPETA A COMPLETAR ⚠️
    ├── 📄 api.php        # Archivo principal API (🔴 A desarrollar)
    ├── 📁 controller/    # Controladores (🔴 A desarrollar)
    │   ├── usuarios.php  # Login y sesiones (🔴 A desarrollar)
    │   └── tarjetas.php  # Gestión de tarjetas (🔴 A desarrollar)
    └── 📁 model/         # Modelos (🔴 A desarrollar)
        ├── usuario.php   # Modelo de usuarios (🔴 A desarrollar)
        └── tarjeta.php   # Modelo de tarjetas (🔴 A desarrollar)
```

---

## 🚀 Funcionalidades a Implementar

### 1. 🔐 **Sistema de Autenticación**
- Validar credenciales de usuario contra la base de datos
- Crear sesiones PHP almacenando:
  - `$_SESSION['usuario_id']` - ID del usuario
  - `$_SESSION['username']` - Nombre de usuario
- Redireccionar según el resultado del login

### 2. 🎴 **Sistema de Tarjetas**
- Cargar tarjetas según el usuario logueado
- Implementar consulta SQL con **INNER JOIN**
- Filtrar por usuario: `WHERE usuario_id = $_SESSION['usuario_id']`

---

## 🗄️ Base de Datos

### 📥 **Importación**
```sql
-- Importar el archivo dragonballz.sql en phpMyAdmin o MySQL
-- Esto creará la base de datos completa con datos de prueba
```

### 🏗️ **Estructura Principal**
```sql
-- Tabla de usuarios
usuarios (id, username, password, email, nombre_completo, ...)

-- Tabla de tarjetas
tarjetas (id, nombre, titulo, descripcion, nivel_poder, raza, ...)

-- Tabla relacional (CLAVE PARA EL EJERCICIO)
usuario_tarjetas (usuario_id, tarjeta_id, fecha_obtencion, ...)
```

### 👥 **Usuarios de Prueba**
| Usuario | Contraseña | Personaje |
|---------|------------|-----------|
| `goku` | `kamehameha123` | Son Goku |
| `vegeta` | `principe123` | Vegeta |
| `gohan` | `mystic123` | Son Gohan |
| `piccolo` | `namek123` | Piccolo |
| `krillin` | `destructo123` | Krillin |
| `yamcha` | `lobo123` | Yamcha |

---

## 💻 Requerimientos Técnicos

### 🔧 **Arquitectura MVC**
Implementar el patrón **Modelo-Vista-Controlador**:

```
📁 api/
├── api.php                    # Router principal
├── controller/
│   ├── usuarios.php          # Controlador de autenticación
│   └── tarjetas.php          # Controlador de tarjetas
└── model/
    ├── usuario.php           # Modelo de usuarios
    └── tarjeta.php           # Modelo de tarjetas
```

### 🛠️ **Tecnologías**
- **Backend:** PHP 7.4+
- **Base de datos:** MySQL/MariaDB
- **Frontend:** HTML5, CSS3, JavaScript (Ya implementado)
- **Servidor:** Apache (XAMPP/LAMP/WAMP)

---

## 📝 Tareas Específicas

### ✅ **Paso 1: Configuración**
1. Importar `dragonballz.sql` en phpMyAdmin
2. Verificar conexión en `conexion.php`
3. Crear estructura de carpetas en `api/`

### ✅ **Paso 2: Modelo de Usuario** (`api/model/usuario.php`)
```php
class Usuario {
    // Método login($username, $password)
    // Consulta SQL con password MD5
    // Retornar datos del usuario si es válido
}
```

### ✅ **Paso 3: Modelo de Tarjeta** (`api/model/tarjeta.php`)
```php
class Tarjeta {
    // Método obtenerTarjetasUsuario($usuario_id)
    // INNER JOIN entre tarjetas y usuario_tarjetas
    // WHERE usuario_id = $_SESSION['usuario_id']
}
```

### ✅ **Paso 4: Controlador de Usuarios** (`api/controller/usuarios.php`)
```php
// Función procesarLogin()
// Validar credenciales
// Crear sesión con usuario_id y username
// Redireccionar a tarjetas.html
```

### ✅ **Paso 5: Controlador de Tarjetas** (`api/controller/tarjetas.php`)
```php
// Función obtenerMisTarjetas()
// Verificar sesión activa
// Retornar tarjetas del usuario en formato JSON
```

### ✅ **Paso 6: API Principal** (`api/api.php`)
```php
// Router que dirija a controladores según parámetros
// Manejar secciones: usuarios, tarjetas
// Manejar acciones: login, mis_tarjetas, etc.
```

---

## 🔍 Consulta SQL Clave

**La consulta más importante del ejercicio:**

```sql
SELECT t.*, ut.fecha_obtencion
FROM tarjetas t
INNER JOIN usuario_tarjetas ut ON t.id = ut.tarjeta_id
WHERE ut.usuario_id = $_SESSION['usuario_id']
ORDER BY ut.fecha_obtencion DESC
```

---

## 🎯 Endpoints a Implementar

### 🔐 **Autenticación**
```
POST /api/api.php?seccion=usuarios&accion=login
- Parámetros: username, password
- Respuesta: Redirección o JSON de error
```

### 🎴 **Tarjetas**
```
GET /api/api.php?seccion=tarjetas&accion=mis_tarjetas
- Requiere: Sesión activa
- Respuesta: JSON con tarjetas del usuario
```

---

## 🧪 Flujo de Pruebas

1. **Acceder:** `http://localhost/ejercicio_login_sesion/index.html`
2. **Login:** Usuario `goku`, contraseña `kamehameha123`
3. **Verificar:** Redirección automática a `tarjetas.html`
4. **Observar:** Carga dinámica de tarjetas del usuario
5. **Comprobar:** Variables de sesión almacenadas correctamente

---

## 📚 Conceptos Clave de la Clase

### 🔄 **Variables de Sesión**
```php
session_start();
$_SESSION['usuario_id'] = $user['id'];
$_SESSION['username'] = $user['username'];
```

### 🔗 **INNER JOIN**
```sql
-- Relacionar tablas usando claves foráneas
SELECT * FROM tabla1 t1
INNER JOIN tabla2 t2 ON t1.id = t2.tabla1_id
WHERE condicion
```

### 🏗️ **Patrón MVC**
- **Modelo:** Lógica de datos y base de datos
- **Vista:** Frontend (HTML/CSS/JS)
- **Controlador:** Lógica de negocio y flujo

---

## 📤 Entrega

### 📋 **Requerimientos de Entrega**
1. ✅ Crear **nuevo repositorio** en GitHub
2. ✅ Subir código completo y funcional
3. ✅ Incluir archivo README con instrucciones
4. ✅ Enviar enlace en plataforma **CREA**

### 🔍 **Criterios de Evaluación**
- ✅ Funcionalidad del login
- ✅ Manejo correcto de sesiones
- ✅ Consulta SQL con INNER JOIN
- ✅ Estructura MVC implementada
- ✅ Código limpio y comentado

---

### 📖 **Documentación**
- [PHP Sessions](https://www.php.net/manual/en/book.session.php)
- [MySQL INNER JOIN](https://dev.mysql.com/doc/refman/8.0/en/join.html)
- [MVC Pattern](https://www.tutorialspoint.com/mvc_framework/mvc_framework_introduction.htm)

---

## 🎉 ¡Que la fuerza del Super Saiyajin los acompañe!

**¡A completar el backend y hacer que este sistema Dragon Ball Z cobre vida!** 🐉⚡

---

*Desarrollado para la clase de Programación Fulls Stack, IAE Colonia del Sacramento - Profe Mariano Bastarreix*
