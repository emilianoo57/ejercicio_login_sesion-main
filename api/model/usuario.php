<?php

class Usuario {
    private $conn;

    public function __construct($conexion) {
        $this->conn = $conexion;
    }

    public function login($username, $password) {
        $stmt = $this->conn->prepare("SELECT * FROM usuarios WHERE username = ?");
        if (!$stmt) {
            return json_encode(["success" => false, "error" => "Error en la consulta de login"]);
        }
        $stmt->bind_param('s', $username);
        $stmt->execute();
        $result =  $stmt->get_result()->fetch_assoc();

        if ($result && password_verify($password, $result['password'])) {
           unset($result['password']);
            if (session_status() === PHP_SESSION_NONE) {
                session_start();
            }
            $_SESSION['usuario'] = $result;
            return json_encode(["success" => true, "usuario" => $result]);
        
        }
        return json_encode(["success" => false, "message" => "Usuario o contraseña incorrectos"]);
        }
    
}
?>