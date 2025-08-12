<?php

class Tarjeta
{
    private $conn;

    public function __construct($conn)
    {
        $this->conn = $conn;
    }

    public function obtenerPorUsuario($usuarioId)
    {
        $sql = "SELECT t.*
                FROM tarjetas t
                INNER JOIN usuario_tarjetas ut ON t.id = ut.tarjeta_id
                WHERE ut.usuario_id = ?";

        $stmt = $this->conn->prepare($sql);

        if (!$stmt) {
            return json_encode([
                "success" => false,
                "error" => "Error al preparar la consulta"
            ]);
        }

        $stmt->bind_param("i", $usuarioId);

        if (!$stmt->execute()) {
            return json_encode([
                "success" => false,
                "error" => "Error al ejecutar la consulta"
            ]);
        }
        $resultado = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

        return json_encode([
            "success" => true,
            "tarjetas" => $resultado,
            "total" => count($resultado)
        ]);
    }

    public function obtenerTodas()
    {
        $stmt = $this->conn->prepare("SELECT * FROM tarjetas");
        if (!$stmt) {
            return json_encode([
                "success" => false,
                "error" => "Error al preparar la consulta"
            ]);
        }

        $stmt->execute();
        $resultado = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

        return json_encode([
            "success" => true,
            "tarjetas" => $resultado,
            "total" => count($resultado)
        ]);
    }
}