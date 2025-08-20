<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.diagnosticomedico2.model.Paciente" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Paciente - Sistema Diagnóstico Médico</title>
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
                <%
                Paciente paciente = (Paciente) request.getAttribute("paciente");
                if (paciente == null) {
                %>
                <div class="alert alert-danger">
                    <h5><i class="fas fa-exclamation-triangle me-2"></i>Error</h5>
                    <p>No se encontró el paciente solicitado.</p>
                    <a href="pacientes" class="btn btn-primary">Volver a la lista</a>
                </div>
                <%
                } else {
                %>
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-user-edit me-2"></i>Editar Paciente
                        </h4>
                    </div>
                    <div class="card-body">
                        <form method="post" action="pacientes">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= paciente.getId() %>">
                            
                            <div class="mb-3">
                                <label for="idDisplay" class="form-label">
                                    <i class="fas fa-id-card me-2"></i>DUI del Paciente
                                </label>
                                <input type="text" class="form-control" id="idDisplay" 
                                       value="<%= paciente.getId() %>" disabled>
                                <div class="form-text">
                                    El DUI del paciente no se puede modificar.
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="nombre" class="form-label">
                                    <i class="fas fa-user me-2"></i>Nombre Completo *
                                </label>
                                <input type="text" class="form-control" id="nombre" name="nombre" 
                                       value="<%= paciente.getNombre() %>"
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
                                       value="<%= paciente.getEdad() %>"
                                       required min="0" max="120">
                                <div class="form-text">
                                    Edad del paciente en años (0-120).
                                </div>
                            </div>
                            
                            <div class="alert alert-info">
                                <h6><i class="fas fa-info-circle me-2"></i>Información del Paciente:</h6>
                                <ul class="mb-0">
                                    <li>Paciente registrado: <strong><%= paciente.getId() %></strong></li>
                                    <li>Diagnósticos realizados: <strong><%= paciente.getDiagnosticos().size() %></strong></li>
                                    <li>Solo se pueden modificar el nombre y la edad</li>
                                </ul>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="pacientes" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times me-2"></i>Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Actualizar Paciente
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Información de diagnósticos -->
                <% if (!paciente.getDiagnosticos().isEmpty()) { %>
                <div class="card mt-4 border-warning">
                    <div class="card-header bg-warning text-dark">
                        <h6 class="mb-0">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Atención: Este paciente tiene diagnósticos
                        </h6>
                    </div>
                    <div class="card-body">
                        <p class="mb-2">
                            Este paciente tiene <strong><%= paciente.getDiagnosticos().size() %></strong> 
                            diagnóstico(s) registrado(s). Los cambios en la información personal no afectarán 
                            el historial médico.
                        </p>
                        <a href="pacientes?action=view&id=<%= paciente.getId() %>" class="btn btn-warning btn-sm">
                            <i class="fas fa-eye me-2"></i>Ver Historial Completo
                        </a>
                    </div>
                </div>
                <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-focus en el campo de nombre
        document.getElementById('nombre').focus();
        
        // Validación adicional del lado del cliente
        document.querySelector('form').addEventListener('submit', function(e) {
            const nombre = document.getElementById('nombre').value.trim();
            const edad = document.getElementById('edad').value;
            
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
    </script>
</body>
</html>
