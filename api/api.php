<?php
// 🐉 DRAGON BALL Z - API PRINCIPAL SIMPLE 🐉
// API reorganizada para manejo de usuarios y tarjetas

// Incluir la conexión
require_once __DIR__ . "/../api/conexion.php";

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
// Establecer cabeceras para API
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

// Obtener parámetros
$requestMethod = $_SERVER["REQUEST_METHOD"];
$seccion = $_GET['seccion'] ?? ''; // Si no existe, asigna cadena vacía
$accion = $_GET['accion'] ?? '';   // Si no existe, asigna cadena vacía

try {
    // ====================================
    // RUTAS PARA USUARIOS (LOGIN/REGISTRO)
    // ====================================
    if ($seccion === 'usuarios') {
        require_once __DIR__ . "/controller/usuarios.php";
        
        switch ($accion) {
            case 'login':
                if ($requestMethod === "POST") {
                    $username = $_POST['username'] ?? '';
                    $password = $_POST['password'] ?? '';
                    Login($username, $password);//funcion del controller
                } else {
                    echo json_encode(["success" => false, "error" => "Método no permitido para login"]);
                }
                break;

           case 'verificar':
                if ($requestMethod === "GET" ) {
                if (isset($_SESSION['usuario'])) {
                    echo verificarSesion(); //funcion del controller
                } else {
                    echo json_encode(["success" => false, "message" => "No hay sesión activa"]);
                }
                } else {
                    echo json_encode(["success" => false, "error" => "Método no permitido para verificar sesión"]);
                }
                break;
                
            default:
                echo json_encode(["success" => false, "error" => "Acción de usuarios no válida"]);
        }
    }
    
    // ====================================
    // RUTAS PARA TARJETAS
    // ====================================
    elseif ($seccion === 'tarjetas') {
        require_once __DIR__ . "/controller/tarjetas.php";
        
        switch ($accion) {
            case 'mis_tarjetas':
                if ($requestMethod === "GET") {
                    obtenerMisTarjetas();//funcion del controller
                } else {
                    echo json_encode(["success" => false, "error" => "Método no permitido"]);
                }
                break;
                
            case 'todas':
                if ($requestMethod === "GET") {
                    obtenerTodasTarjetas();//funcion del controller
                } else {
                    echo json_encode(["success" => false, "error" => "Método no permitido"]);
                }
                break;
                
        
                
            default:
                echo json_encode(["success" => false, "error" => "Acción de tarjetas no válida"]);
        }
    }
    
    // ====================================
    // DOCUMENTACIÓN DE LA API
    // ====================================
    elseif (empty($seccion)) {
        if ($requestMethod === "GET") {
            echo json_encode([
                "success" => true,
                "message" => "🐉 API Dragon Ball Z - Sistema Simple 🐉",
                "version" => "2.0.0",
                "estructura" => [
                    "🔧 Conexión" => "mysqli simple",
                    "👤 Sesión" => "Solo ID y username",
                    "🔒 Seguridad" => "Verificación de login para tarjetas"
                ],
                "endpoints" => [
                    "usuarios" => [
                        "login" => "POST /api.php?seccion=usuarios&accion=login [username, password]",
                        "register" => "POST /api.php?seccion=usuarios&accion=register [datos]", 
                        "logout" => "POST /api.php?seccion=usuarios&accion=logout",
                        "verificar" => "GET /api.php?seccion=usuarios&accion=verificar",
                        "perfil" => "GET /api.php?seccion=usuarios&accion=perfil"
                    ],
                    "tarjetas" => [
                        "mis_tarjetas" => "GET /api.php?seccion=tarjetas&accion=mis_tarjetas (🔒 requiere login)",
                        "todas" => "GET /api.php?seccion=tarjetas&accion=todas",
                        "asignar" => "POST /api.php?seccion=tarjetas&accion=asignar [tarjeta_id] (🔒 requiere login)",
                        "favorita" => "POST /api.php?seccion=tarjetas&accion=favorita [tarjeta_id] (🔒 requiere login)"
                    ]
                ],
                "mensajes_especiales" => [
                    "sin_login" => "🔒 Usted debe iniciar sesión para ver las tarjetas",
                    "login_exitoso" => "🚀 ¡Bienvenido al Torneo!",
                    "tarjeta_obtenida" => "🎉 ¡Nueva tarjeta obtenida!"
                ]
            ]);
        } else {
            echo json_encode(["success" => false, "error" => "Método no permitido"]);
        }
    }
    
    // ====================================
    // SECCIÓN NO ENCONTRADA
    // ====================================
    else {
        echo json_encode([
            "success" => false, 
            "error" => "❌ Sección no encontrada: {$seccion}",
            "secciones_disponibles" => ["usuarios", "tarjetas"],
            "ayuda" => "Usa /api.php sin parámetros para ver la documentación"
        ]);
    }
    
} catch (Exception $e) {
    echo json_encode([
        "success" => false,
        "error" => "💥 Error interno del servidor",
        "debug" => $e->getMessage()
    ]);
}
?>
