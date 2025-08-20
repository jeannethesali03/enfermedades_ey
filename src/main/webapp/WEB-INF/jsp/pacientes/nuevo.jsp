<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuevo Paciente - Sistema Diagnóstico Médico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-stethoscope me-2"></i>
                Sistema Diagnóstico Médico
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/sintomas">Síntomas</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/enfermedades">Enfermedades</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/pacientes">Pacientes</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/diagnostico">Diagnóstico</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/reportes">Reportes</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-user-plus me-2"></i>Registrar Nuevo Paciente
                        </h4>
                    </div>
                    <div class="card-body">
                        <form method="post" action="pacientes">
                            <input type="hidden" name="action" value="create">
                            
                            <div class="mb-3">
                                <label for="id" class="form-label">
                                    <i class="fas fa-id-card me-2"></i>DUI del Paciente *
                                </label>
                                <input type="text" class="form-control" id="id" name="id" 
                                       placeholder="00000000-0" 
                                       required maxlength="10" minlength="10"
                                       pattern="^[0-9]{8}-[0-9]$"
                                       title="Formato: 12345678-9">
                                <div class="form-text">
                                    Número de DUI del paciente. Formato: 12345678-9 (el guión se agrega automáticamente).
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="nombre" class="form-label">
                                    <i class="fas fa-user me-2"></i>Nombre Completo *
                                </label>
                                <input type="text" class="form-control" id="nombre" name="nombre" 
                                       placeholder="Ej: Juan Pérez García" 
                                       required maxlength="100" minlength="3"
                                       pattern="^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$"
                                       title="Solo se permiten letras, espacios y acentos">
                                <div class="form-text">
                                    Solo letras, espacios y acentos. Mínimo 3 caracteres, no se permiten números.
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="edad" class="form-label">
                                    <i class="fas fa-birthday-cake me-2"></i>Edad *
                                </label>
                                <input type="number" class="form-control" id="edad" name="edad" 
                                       placeholder="Ej: 25" 
                                       required min="0" max="120">
                                <div class="form-text">
                                    Edad del paciente en años (0-120).
                                </div>
                            </div>
                            
                            <div class="alert alert-info">
                                <h6><i class="fas fa-info-circle me-2"></i>Criterios de Validación:</h6>
                                <ul class="mb-0">
                                    <li><strong>El DUI debe ser único en el sistema</strong></li>
                                    <li><strong>Formato DUI: 12345678-9 (8 dígitos + guión + 1 dígito)</strong></li>
                                    <li>El nombre debe tener al menos 3 caracteres</li>
                                    <li>El nombre solo puede contener letras, espacios y acentos</li>
                                    <li>No se permiten números ni símbolos en el nombre</li>
                                    <li>La edad debe estar entre 0 y 120 años</li>
                                    <li>Todos los campos son obligatorios</li>
                                </ul>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="pacientes" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times me-2"></i>Cancelar
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save me-2"></i>Guardar Paciente
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Información adicional -->
                <div class="card mt-4 border-warning">
                    <div class="card-header bg-warning text-dark">
                        <h6 class="mb-0"><i class="fas fa-lightbulb me-2"></i>Consejos</h6>
                    </div>
                    <div class="card-body">
                        <h6>Ejemplos de DUI válidos:</h6>
                        <ul class="list-unstyled">
                            <li><i class="fas fa-id-card text-primary me-2"></i>12345678-9</li>
                            <li><i class="fas fa-id-card text-success me-2"></i>98765432-1</li>
                            <li><i class="fas fa-id-card text-info me-2"></i>11223344-5</li>
                            <li><i class="fas fa-id-card text-warning me-2"></i>55667788-0</li>
                        </ul>
                        <p class="mb-0 text-muted">
                            <strong>Nota:</strong> El DUI debe tener exactamente 8 dígitos, seguido de un guión 
                            y un dígito verificador. El guión se agregará automáticamente mientras escribe.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-focus en el campo de DUI
        document.getElementById('id').focus();
        
        // Formateo automático del DUI
        document.getElementById('id').addEventListener('input', function(e) {
            let valor = e.target.value.replace(/\D/g, ''); // Solo números
            
            // Limitar a 9 dígitos máximo
            if (valor.length > 9) {
                valor = valor.substring(0, 9);
            }
            
            // Agregar guión automáticamente después del 8vo dígito
            if (valor.length > 8) {
                valor = valor.substring(0, 8) + '-' + valor.substring(8);
            }
            
            e.target.value = valor;
            
            // Validación visual
            const regexDUI = /^[0-9]{8}-[0-9]$/;
            if (valor.length === 10 && regexDUI.test(valor)) {
                e.target.classList.remove('is-invalid');
                e.target.classList.add('is-valid');
            } else if (valor.length > 0) {
                e.target.classList.remove('is-valid');
                if (valor.length === 10) {
                    e.target.classList.add('is-invalid');
                }
            } else {
                e.target.classList.remove('is-valid', 'is-invalid');
            }
        });
        
        // Permitir solo números y guión, y controlar longitud
        document.getElementById('id').addEventListener('keypress', function(e) {
            const char = String.fromCharCode(e.which);
            const currentValue = e.target.value;
            
            // Permitir teclas de control (backspace, delete, etc.)
            if (e.which <= 32) return true;
            
            // Solo números
            if (!/[0-9]/.test(char)) {
                e.preventDefault();
                return false;
            }
            
            // No permitir más de 9 dígitos
            const numCount = currentValue.replace(/\D/g, '').length;
            if (numCount >= 9) {
                e.preventDefault();
                return false;
            }
        });
        
        // Validación adicional del lado del cliente
        document.querySelector('form').addEventListener('submit', function(e) {
            const dui = document.getElementById('id').value.trim();
            const nombre = document.getElementById('nombre').value.trim();
            const edad = document.getElementById('edad').value;
            
            // Validar formato DUI
            const regexDUI = /^[0-9]{8}-[0-9]$/;
            if (!regexDUI.test(dui)) {
                alert('El DUI debe tener el formato correcto: 12345678-9 (8 dígitos, guión, 1 dígito).');
                e.preventDefault();
                return;
            }
            
            if (nombre.length < 3) {
                alert('El nombre debe tener al menos 3 caracteres.');
                e.preventDefault();
                return;
            }
            
            // Validar que el nombre solo contenga letras, espacios y acentos
            const regexNombre = /^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$/;
            if (!regexNombre.test(nombre)) {
                alert('El nombre solo puede contener letras, espacios y acentos. No se permiten números ni símbolos.');
                e.preventDefault();
                return;
            }
            
            if (edad < 0 || edad > 120) {
                alert('La edad debe estar entre 0 y 120 años.');
                e.preventDefault();
                return;
            }
        });
        
        // Validación en tiempo real para el nombre
        document.getElementById('nombre').addEventListener('input', function(e) {
            const valor = e.target.value;
            const regexNombre = /^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]*$/;
            
            if (!regexNombre.test(valor)) {
                e.target.classList.add('is-invalid');
                // Remover caracteres no válidos
                e.target.value = valor.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]/g, '');
            } else {
                e.target.classList.remove('is-invalid');
            }
        });
        
        // Agregar tooltip informativo
        document.getElementById('id').setAttribute('title', 'Ingrese los 9 dígitos del DUI. El guión se agregará automáticamente.');
    </script>
</body>
</html>
