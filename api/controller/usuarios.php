<?php 
require_once __DIR__ . "/../model/usuario.php";


$usuarioModel = new Usuario($conn);
function Login($username, $password) {
    global $usuarioModel;
    echo $usuarioModel->login($username, $password);

    }
    function verificarSesion() {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        if (isset($_SESSION['usuario'])) {
            echo json_encode(["success" => true, "logueado" => true, "usuario" => $_SESSION['usuario']]);
        } else {
            echo json_encode(["success" => true, "logueado" => true]);
        }
    }
    
    function obtenerPerfilUsuario() {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        if (isset($_SESSION['usuario'])) {
 echo json_encode(["success" => true, "logueado" => true, "usuario" => $_SESSION['usuario']]);    
        } else {
            echo json_encode(["success" => false, "logueado" => false, "message" => "No hay sesión activa"]);
            $usuario = null;
        }
        echo json_encode(["success" => true, "data" => "Aquí va el perfil del usuario"]);
    }
