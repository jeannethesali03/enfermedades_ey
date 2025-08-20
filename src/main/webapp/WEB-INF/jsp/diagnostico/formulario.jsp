<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Sintoma" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Paciente" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diagnóstico Médico - Sistema Diagnóstico Médico</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/pacientes">Pacientes</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/diagnostico">Diagnóstico</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/reportes">Reportes</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-diagnoses me-2"></i>Realizar Diagnóstico Médico</h2>
                    <a href="diagnostico?action=historial" class="btn btn-outline-primary">
                        <i class="fas fa-history me-2"></i>Ver Historial
                    </a>
                </div>

                <!-- Mostrar mensajes -->
                <% 
                String mensaje = (String) request.getAttribute("mensaje");
                String tipoMensaje = (String) request.getAttribute("tipoMensaje");
                if (mensaje != null && !mensaje.isEmpty()) {
                %>
                <div class="alert alert-<%= "error".equals(tipoMensaje) ? "danger" : "success" %> alert-dismissible fade show" role="alert">
                    <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <%
                List<Sintoma> sintomas = (List<Sintoma>) request.getAttribute("sintomas");
                List<Paciente> pacientes = (List<Paciente>) request.getAttribute("pacientes");
                
                if (sintomas.isEmpty() || pacientes.isEmpty()) {
                %>
                <!-- Mensaje de error si no hay datos suficientes -->
                <div class="card border-danger">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0"><i class="fas fa-exclamation-triangle me-2"></i>Requisitos No Cumplidos</h5>
                    </div>
                    <div class="card-body">
                        <p>Para realizar un diagnóstico médico, el sistema requiere:</p>
                        <ul>
                            <li>Al menos un síntoma registrado</li>
                            <li>Al menos una enfermedad registrada</li>
                            <li>Al menos un paciente registrado</li>
                        </ul>
                        <hr>
                        <div class="row">
                            <% if (sintomas.isEmpty()) { %>
                            <div class="col-md-4 mb-2">
                                <a href="${pageContext.request.contextPath}/sintomas" class="btn btn-warning w-100">
                                    <i class="fas fa-clipboard-list me-2"></i>Registrar Síntomas
                                </a>
                            </div>
                            <% } %>
                            <div class="col-md-4 mb-2">
                                <a href="${pageContext.request.contextPath}/enfermedades" class="btn btn-info w-100">
                                    <i class="fas fa-virus me-2"></i>Registrar Enfermedades
                                </a>
                            </div>
                            <% if (pacientes.isEmpty()) { %>
                            <div class="col-md-4 mb-2">
                                <a href="${pageContext.request.contextPath}/pacientes" class="btn btn-success w-100">
                                    <i class="fas fa-users me-2"></i>Registrar Pacientes
                                </a>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <%
                } else {
                %>
                <!-- Formulario de diagnóstico -->
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Formulario de Diagnóstico</h5>
                            </div>
                            <div class="card-body">
                                <form method="post" action="diagnostico" id="formDiagnostico">
                                    <input type="hidden" name="action" value="realizar">
                                    
                                    <!-- Selección de paciente -->
                                    <div class="mb-4">
                                        <label for="pacienteId" class="form-label">
                                            <i class="fas fa-user me-2"></i>Seleccione el Paciente *
                                        </label>
                                        <select class="form-select" id="pacienteId" name="pacienteId" required>
                                            <option value="">-- Seleccione un paciente --</option>
                                            <% for (Paciente paciente : pacientes) { %>
                                            <option value="<%= paciente.getId() %>">
                                                <%= paciente.getId() %> - <%= paciente.getNombre() %> (<%= paciente.getEdad() %> años)
                                            </option>
                                            <% } %>
                                        </select>
                                    </div>
                                    
                                    <!-- Selección de síntomas -->
                                    <div class="mb-4">
                                        <label class="form-label">
                                            <i class="fas fa-clipboard-list me-2"></i>Síntomas Presentados *
                                        </label>
                                        <div class="form-text mb-3">
                                            Seleccione todos los síntomas que presenta el paciente:
                                        </div>
                                        
                                        <div class="row" id="sintomasContainer">
                                            <% for (Sintoma sintoma : sintomas) { %>
                                            <div class="col-md-6 mb-3">
                                                <div class="card h-100">
                                                    <div class="card-body p-3">
                                                        <div class="form-check">
                                                            <input class="form-check-input" type="checkbox" 
                                                                   name="sintomas" value="<%= sintoma.getId() %>" 
                                                                   id="sintoma<%= sintoma.getId() %>">
                                                            <label class="form-check-label fw-bold" for="sintoma<%= sintoma.getId() %>">
                                                                <%= sintoma.getNombre() %>
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                    
                                    <div class="alert alert-info">
                                        <h6><i class="fas fa-info-circle me-2"></i>Proceso de Diagnóstico:</h6>
                                        <ol class="mb-0">
                                            <li>El sistema comparará los síntomas seleccionados con las enfermedades registradas</li>
                                            <li>Si hay coincidencia exacta, se mostrará el diagnóstico con 100% de certeza</li>
                                            <li>Si no hay coincidencia exacta, se mostrarán las 3 enfermedades más probables</li>
                                            <li>El resultado se guardará en el historial del paciente</li>
                                        </ol>
                                    </div>
                                    
                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <a href="${pageContext.request.contextPath}/" class="btn btn-secondary me-md-2">
                                            <i class="fas fa-times me-2"></i>Cancelar
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-diagnoses me-2"></i>Realizar Diagnóstico
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Panel de información -->
                    <div class="col-lg-4">
                        <div class="card border-info">
                            <div class="card-header bg-info text-white">
                                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Información del Sistema</h6>
                            </div>
                            <div class="card-body">
                                <p class="mb-2"><strong>Síntomas disponibles:</strong> <%= sintomas.size() %></p>
                                <p class="mb-2"><strong>Pacientes registrados:</strong> <%= pacientes.size() %></p>
                                <hr>
                                <h6>Instrucciones:</h6>
                                <ol class="small">
                                    <li>Seleccione el paciente</li>
                                    <li>Marque todos los síntomas que presenta</li>
                                    <li>Haga clic en "Realizar Diagnóstico"</li>
                                    <li>Revise el resultado generado</li>
                                </ol>
                            </div>
                        </div>
                        
                        <div class="card border-warning mt-3">
                            <div class="card-header bg-warning text-dark">
                                <h6 class="mb-0"><i class="fas fa-exclamation-triangle me-2"></i>Importante</h6>
                            </div>
                            <div class="card-body">
                                <p class="mb-0 small">
                                    Este sistema es una herramienta de ayuda al diagnóstico. 
                                    Los resultados deben ser interpretados por personal médico calificado.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validación del formulario
        document.getElementById('formDiagnostico')?.addEventListener('submit', function(e) {
            const pacienteId = document.getElementById('pacienteId').value;
            const sintomasSeleccionados = document.querySelectorAll('input[name="sintomas"]:checked');
            
            if (!pacienteId) {
                alert('Debe seleccionar un paciente.');
                e.preventDefault();
                return;
            }
            
            if (sintomasSeleccionados.length === 0) {
                alert('Debe seleccionar al menos un síntoma.');
                e.preventDefault();
                return;
            }
            
            // Confirmación antes de proceder
            const confirmacion = confirm(
                `¿Confirma realizar el diagnóstico para el paciente seleccionado con ${sintomasSeleccionados.length} síntoma(s)?`
            );
            
            if (!confirmacion) {
                e.preventDefault();
            }
        });
        
        // Destacar síntomas seleccionados
        document.querySelectorAll('input[name="sintomas"]').forEach(function(checkbox) {
            checkbox.addEventListener('change', function() {
                const card = this.closest('.card');
                if (this.checked) {
                    card.classList.add('border-primary');
                    card.classList.add('bg-light');
                } else {
                    card.classList.remove('border-primary');
                    card.classList.remove('bg-light');
                }
            });
        });
    </script>
</body>
</html>
