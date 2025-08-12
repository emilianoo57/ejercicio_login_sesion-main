// 🐉 Dragon Ball Z - Sistema de Guerreros Dinámico 🐉
// Carga dinámica de tarjetas desde la API

// Configuración de la API
const API_CONFIG = {
    baseUrl: 'http://localhost/ejercicio_login_sesion-main/api/api.php',
    endpoints: {
        todasTarjetas: '?seccion=tarjetas&accion=todas',
        misTarjetas: '?seccion=tarjetas&accion=mis_tarjetas',
        verificarSesion: '?seccion=usuarios&accion=verificar'
    }
};

// Estado de la aplicación
let estadoApp = {
    tarjetasCargadas: false,
    usuarioLogueado: false,
    tarjetas: []
};

/**
 * Función principal que se ejecuta al cargar la página
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('🐉 Iniciando sistema Dragon Ball Z...');
    verificarSesionYCargarTarjetas();
});

/**
 * Verifica si hay sesión activa y carga las tarjetas correspondientes
 */
async function verificarSesionYCargarTarjetas() {
    try {
        mostrarCargando();
        
        // Verificar si hay sesión activa
        const sesionResponse = await fetch(API_CONFIG.baseUrl + API_CONFIG.endpoints.verificarSesion);
        const sesionData = await sesionResponse.json();
        
        if (sesionData.success && sesionData.logueado) {
            estadoApp.usuarioLogueado = true;
            console.log(`🚀 Usuario logueado: ${sesionData.usuario.username}`);
            
            // Mostrar información del usuario en la interfaz
            mostrarInfoUsuario(sesionData.usuario);
            
            await cargarMisTarjetas();
        } else {
            estadoApp.usuarioLogueado = false;
            console.log('👤 No hay sesión activa, cargando todas las tarjetas');
            await cargarTodasTarjetas();
        }
    } catch (error) {
        console.error('❌ Error al verificar sesión:', error);
        mostrarError('Error al conectar con el servidor de los Guerreros Z');
    }
}

/**
 * Carga las tarjetas del usuario logueado
 */
async function cargarMisTarjetas() {
    try {
        const response = await fetch(API_CONFIG.baseUrl + API_CONFIG.endpoints.misTarjetas);
        const data = await response.json();
        
        if (data.success) {
            console.log(`🎴 Mis tarjetas cargadas: ${data.tarjetas.length}`);
            estadoApp.tarjetas = data.tarjetas;
            renderizarTarjetas(data.tarjetas, `🎴 Mis Tarjetas (${data.total})`);
        } else {
            if (data.requiere_login) {
                // Usuario no logueado, cargar todas las tarjetas
                await cargarTodasTarjetas();
            } else {
                mostrarError(data.error || 'Error al cargar tus tarjetas');
            }
        }
    } catch (error) {
        console.error('❌ Error al cargar mis tarjetas:', error);
        mostrarError('Error al cargar tus tarjetas de combate');
    }
}

/**
 * Carga todas las tarjetas disponibles
 */
async function cargarTodasTarjetas() {
    try {
        const response = await fetch(API_CONFIG.baseUrl + API_CONFIG.endpoints.todasTarjetas);
        const data = await response.json();
        
        if (data.success) {
            console.log(`🎴 Todas las tarjetas cargadas: ${data.tarjetas.length}`);
            estadoApp.tarjetas = data.tarjetas;
            renderizarTarjetas(data.tarjetas, `🎴 Todos los Guerreros (${data.total})`);
        } else {
            mostrarError(data.error || 'Error al cargar las tarjetas');
        }
    } catch (error) {
        console.error('❌ Error al cargar todas las tarjetas:', error);
        mostrarError('Error al invocar a los Guerreros Z');
    }
}

/**
 * Renderiza las tarjetas en el DOM
 */
function renderizarTarjetas(tarjetas, titulo = '') {
    const container = document.getElementById('cards-container');
    
    if (!tarjetas || tarjetas.length === 0) {
        mostrarEstadoVacio();
        return;
    }
    
    // Actualizar título si existe
    if (titulo) {
        const header = document.querySelector('header h1');
        if (header) {
            header.textContent = `🐉 ${titulo} 🐉`;
        }
    }
    
    // Limpiar container
    container.innerHTML = '';
    
    // Crear tarjetas
    tarjetas.forEach((tarjeta, index) => {
        const cardElement = crearElementoTarjeta(tarjeta);
        cardElement.style.animationDelay = `${index * 0.1}s`;
        container.appendChild(cardElement);
    });
    
    estadoApp.tarjetasCargadas = true;
    console.log(`✅ ${tarjetas.length} tarjetas renderizadas`);
}

/**
 * Crea el elemento HTML para una tarjeta
 */
function crearElementoTarjeta(tarjeta) {
    const card = document.createElement('div');
    card.className = 'card fade-in';
    card.dataset.tarjetaId = tarjeta.id;
    
    // Determinar emoji según la raza
    const emojiRaza = obtenerEmojiPorRaza(tarjeta.raza);
    
    // Crear URL de imagen placeholder con el nombre del personaje
    const imagePlaceholder = `https://via.placeholder.com/300x200/${obtenerColorPorRareza(tarjeta.rareza)}/white?text=${encodeURIComponent(tarjeta.nombre.toUpperCase())}+${emojiRaza}`;
    
    card.innerHTML = `
        <img src="${tarjeta.imagen_url || imagePlaceholder}" 
             alt="${tarjeta.nombre} - ${tarjeta.titulo}"
             onerror="this.src='${imagePlaceholder}'">
        <div class="card-content">
            <h3>${emojiRaza} ${tarjeta.nombre}</h3>
            <p class="card-titulo">${tarjeta.titulo}</p>
            <p class="card-descripcion">${tarjeta.descripcion}</p>
            <div class="card-stats">
                <span class="nivel-poder">⚡ Poder: ${formatearNumeroPoder(tarjeta.nivel_poder)}</span>
                <span class="rareza rareza-${tarjeta.rareza.toLowerCase().replace(' ', '-')}">${tarjeta.rareza}</span>
            </div>
            ${tarjeta.tecnica_principal ? `<p class="tecnica">🥋 ${tarjeta.tecnica_principal}</p>` : ''}
            <button class="card-btn" onclick="verDetallesTarjeta(${tarjeta.id})">
                ${obtenerTextoBoton(tarjeta.rareza)} Ver Poder
            </button>
        </div>
    `;
    
    return card;
}

/**
 * Obtiene el emoji correspondiente a la raza
 */
function obtenerEmojiPorRaza(raza) {
    const emojis = {
        'Saiyajin': '🥋',
        'Humano': '👤',
        'Namekiano': '🧘',
        'Androide': '🤖',
        'Majin': '👹',
        'Frieza': '❄️',
        'Híbrido': '⭐'
    };
    return emojis[raza] || '🔥';
}

/**
 * Obtiene el color para el placeholder según la rareza
 */
function obtenerColorPorRareza(rareza) {
    const colores = {
        'Mítico': 'FF1493',
        'Legendario': '7B68EE',
        'Épico': 'FF6B00',
        'Raro': 'FFD700',
        'Poco Común': '32CD32',
        'Común': '808080'
    };
    return colores[rareza] || 'FF6B00';
}

/**
 * Obtiene el texto del botón según la rareza
 */
function obtenerTextoBoton(rareza) {
    const botones = {
        'Mítico': '💫',
        'Legendario': '🌟',
        'Épico': '⚡',
        'Raro': '💥',
        'Poco Común': '🔥',
        'Común': '💪'
    };
    return botones[rareza] || '⚡';
}

/**
 * Formatea el número de poder para mostrar
 */
function formatearNumeroPoder(poder) {
    if (poder >= 1000000) {
        return (poder / 1000000).toFixed(1) + 'M';
    } else if (poder >= 1000) {
        return (poder / 1000).toFixed(1) + 'K';
    }
    return poder.toString();
}

/**
 * Muestra el estado de carga
 */
function mostrarCargando() {
    const container = document.getElementById('cards-container');
    const loadingElement = document.getElementById('loading');
    const errorElement = document.getElementById('error-message');
    
    if (loadingElement) loadingElement.style.display = 'flex';
    if (errorElement) errorElement.style.display = 'none';
}

/**
 * Muestra un mensaje de error
 */
function mostrarError(mensaje) {
    const container = document.getElementById('cards-container');
    const loadingElement = document.getElementById('loading');
    const errorElement = document.getElementById('error-message');
    const errorText = document.getElementById('error-text');
    
    if (loadingElement) loadingElement.style.display = 'none';
    if (errorElement) {
        errorElement.style.display = 'block';
        if (errorText) errorText.textContent = mensaje;
    }
}

/**
 * Muestra estado vacío cuando no hay tarjetas
 */
function mostrarEstadoVacio() {
    const container = document.getElementById('cards-container');
    container.innerHTML = `
        <div class="empty-state">
            <h3>🐉 No hay guerreros disponibles</h3>
            <p>Parece que todos los guerreros están entrenando en la Sala del Tiempo y el Espacio.</p>
        </div>
    `;
}

/**
 * Muestra la información del usuario logueado en la interfaz
 */
function mostrarInfoUsuario(usuario) {
    const userInfo = document.getElementById('user-info');
    const welcomeMessage = document.getElementById('welcome-message');
    
    if (userInfo && welcomeMessage) {
        welcomeMessage.textContent = `🥋 Bienvenido, ${usuario.username}!`;
        userInfo.style.display = 'flex';
        
        // Actualizar título de la página
        document.title = `Mis Tarjetas - ${usuario.username} | Dragon Ball Z`;
    }
}

/**
 * Función para recargar las tarjetas (botón de reintentar)
 */
function cargarTarjetas() {
    estadoApp.tarjetasCargadas = false;
    verificarSesionYCargarTarjetas();
}

/**
 * Ver detalles de una tarjeta específica
 */
function verDetallesTarjeta(tarjetaId) {
    const tarjeta = estadoApp.tarjetas.find(t => t.id == tarjetaId);
    if (tarjeta) {
        console.log('🎴 Mostrando detalles de:', tarjeta.nombre);
        
        // Aquí puedes implementar un modal o redirección
        alert(`🐉 ${tarjeta.nombre} - ${tarjeta.titulo}\n\n` +
              `💪 Nivel de Poder: ${formatearNumeroPoder(tarjeta.nivel_poder)}\n` +
              `🏆 Rareza: ${tarjeta.rareza}\n` +
              `🧬 Raza: ${tarjeta.raza}\n` +
              `🥋 Técnica: ${tarjeta.tecnica_principal || 'Técnicas básicas'}\n` +
              `📖 Serie: ${tarjeta.serie || 'Dragon Ball Z'}\n\n` +
              `${tarjeta.descripcion}`);
    }
}

// Funciones de utilidad para debugging
window.dbzDebug = {
    estadoApp: () => estadoApp,
    recargar: () => cargarTarjetas(),
    tarjetas: () => estadoApp.tarjetas
};
