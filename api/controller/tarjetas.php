<?php

require_once __DIR__ . '/../model/tarjeta.php';

$tarjetaModel = new Tarjeta($conn);

function obtenerMisTarjetas()
{
    global $conn;

    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    if (!isset($_SESSION['usuario'])) {
        echo json_encode([
            "success" => false,
            "requiere_login" => true,
            "message" => "Debes iniciar sesión"
        ]);
        return;
    }

    $usuarioId = $_SESSION['usuario']['id'];

    $sql = "SELECT t.*
            FROM tarjetas t
            INNER JOIN usuario_tarjetas ut ON t.id = ut.tarjeta_id
            WHERE ut.usuario_id = ?";

    $stmt = $conn->prepare($sql);
    
    if (!$stmt) {
        echo json_encode([
            "success" => false,
            "error" => "Error al preparar la consulta"
        ]);
        return;
    }

    $stmt->bind_param("i", $usuarioId);

    if (!$stmt->execute()) {
        echo json_encode([
            "success" => false,
            "error" => "Error al ejecutar la consulta"
        ]);
        return;
    }
    $resultado = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    if (empty($resultado)) {
        echo json_encode([
            "success" => true,
            "message" => "No tienes tarjetas asociadas"
        ]);
        return;
    }
    echo json_encode([
        "success" => true,
        "tarjetas" => $resultado,
        "total" => count($resultado)
    ]);
}
function obtenerTodasTarjetas()
{
    global $tarjetaModel;
    echo $tarjetaModel->obtenerTodas();
}