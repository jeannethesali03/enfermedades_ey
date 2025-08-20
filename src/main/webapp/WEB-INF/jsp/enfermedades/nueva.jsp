<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Sintoma" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Enfermedad - Sistema Diagnóstico Médico</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/enfermedades">Enfermedades</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/pacientes">Pacientes</a>
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
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-plus me-2"></i>Registrar Nueva Enfermedad
                        </h4>
                    </div>
                    <div class="card-body">
                        <form method="post" action="enfermedades" id="formEnfermedad">
                            <input type="hidden" name="action" value="create">
                            
                            <div class="mb-4">
                                <label for="nombre" class="form-label">
                                    <i class="fas fa-virus me-2"></i>Nombre de la Enfermedad *
                                </label>
                                <input type="text" class="form-control" id="nombre" name="nombre" 
                                       placeholder="Ej: Gripe, Resfriado común, Bronquitis..." 
                                       required maxlength="100" minlength="3">
                                <div class="form-text">
                                    Ingrese un nombre descriptivo para la enfermedad (mínimo 3 caracteres).
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label">
                                    <i class="fas fa-clipboard-list me-2"></i>Síntomas Asociados *
                                </label>
                                <div class="form-text mb-3">
                                    Seleccione los síntomas que caracterizan esta enfermedad (debe seleccionar al menos uno).
                                </div>
                                
                                <% 
                                List<Sintoma> sintomas = (List<Sintoma>) request.getAttribute("sintomas");
                                if (sintomas != null && !sintomas.isEmpty()) {
                                %>
                                <div class="row">
                                    <% for (Sintoma sintoma : sintomas) { %>
                                    <div class="col-md-6 mb-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" 
                                                   name="sintomas" value="<%= sintoma.getId() %>" 
                                                   id="sintoma<%= sintoma.getId() %>">
                                            <label class="form-check-label" for="sintoma<%= sintoma.getId() %>">
                                                <%= sintoma.getNombre() %>
                                            </label>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                                <% } else { %>
                                <div class="alert alert-warning">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    No hay síntomas registrados. 
                                    <a href="${pageContext.request.contextPath}/sintomas" class="alert-link">
                                        Registre síntomas primero.
                                    </a>
                                </div>
                                <% } %>
                            </div>
                            
                            <div class="alert alert-info">
                                <h6><i class="fas fa-info-circle me-2"></i>Criterios de Validación:</h6>
                                <ul class="mb-0">
                                    <li>El nombre no puede estar vacío</li>
                                    <li>Debe tener al menos 3 caracteres</li>
                                    <li>Debe seleccionar al menos un síntoma</li>
                                    <li>No se pueden registrar enfermedades duplicadas</li>
                                    <li>Máximo 10 enfermedades en total</li>
                                </ul>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="enfermedades" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times me-2"></i>Cancelar
                                </a>
                                <% if (sintomas != null && !sintomas.isEmpty()) { %>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save me-2"></i>Guardar Enfermedad
                                </button>
                                <% } %>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Información adicional -->
                <div class="card mt-4 border-warning">
                    <div class="card-header bg-warning text-dark">
                        <h6 class="mb-0"><i class="fas fa-lightbulb me-2"></i>Consejos para el Registro</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Ejemplos de Enfermedades:</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-thermometer-half text-danger me-2"></i>Gripe (fiebre, tos, dolor corporal)</li>
                                    <li><i class="fas fa-head-side-cough text-warning me-2"></i>Resfriado (tos, congestión nasal)</li>
                                    <li><i class="fas fa-stomach text-success me-2"></i>Gastritis (dolor estomacal, náuseas)</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6>Recomendaciones:</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-check text-success me-2"></i>Sea específico con el nombre</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Seleccione síntomas característicos</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Incluya síntomas principales</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-focus en el campo de nombre
        document.getElementById('nombre').focus();
        
        // Validación de formulario
        document.getElementById('formEnfermedad').addEventListener('submit', function(e) {
            const checkboxes = document.querySelectorAll('input[name="sintomas"]:checked');
            if (checkboxes.length === 0) {
                e.preventDefault();
                alert('Debe seleccionar al menos un síntoma para la enfermedad.');
                return false;
            }
        });
    </script>
</body>
</html>
