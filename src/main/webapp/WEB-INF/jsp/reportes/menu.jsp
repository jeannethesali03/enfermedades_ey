<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Paciente" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reportes - Sistema Diagnóstico Médico</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/diagnostico">Diagnóstico</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/reportes">Reportes</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="text-center mb-5">
                    <h2><i class="fas fa-file-pdf me-2"></i>Centro de Reportes</h2>
                    <p class="lead text-muted">Genere reportes en PDF de diagnósticos médicos</p>
                </div>

                <!-- Tipos de reportes -->
                <div class="row g-4">
                    <!-- Reporte Global -->
                    <div class="col-md-6">
                        <div class="card h-100 border-primary">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">
                                    <i class="fas fa-globe me-2"></i>Reporte Global
                                </h5>
                            </div>
                            <div class="card-body">
                                <p class="card-text">
                                    Genere un reporte completo con todos los diagnósticos realizados en el sistema, 
                                    incluyendo estadísticas generales y resumen por paciente.
                                </p>
                                
                                <h6>Incluye:</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-check text-success me-2"></i>Resumen general del sistema</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Total de síntomas, enfermedades y pacientes</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Diagnósticos exactos vs aproximados</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Tabla completa de todos los diagnósticos</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Enfermedades más diagnosticadas</li>
                                </ul>
                            </div>
                            <div class="card-footer">
                                <a href="reportes?action=global" class="btn btn-primary w-100">
                                    <i class="fas fa-download me-2"></i>Descargar Reporte Global (PDF)
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Reporte por Paciente -->
                    <div class="col-md-6">
                        <div class="card h-100 border-success">
                            <div class="card-header bg-success text-white">
                                <h5 class="mb-0">
                                    <i class="fas fa-user-md me-2"></i>Reporte por Paciente
                                </h5>
                            </div>
                            <div class="card-body">
                                <p class="card-text">
                                    Genere un reporte detallado del historial médico de un paciente específico, 
                                    con todos sus diagnósticos y evolución.
                                </p>
                                
                                <h6>Incluye:</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-check text-success me-2"></i>Información personal del paciente</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Historial completo de diagnósticos</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Síntomas presentados en cada consulta</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Diagnósticos exactos y aproximados</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Fechas y detalles de cada consulta</li>
                                </ul>
                            </div>
                            <div class="card-footer">
                                <%
                                List<Paciente> pacientes = (List<Paciente>) request.getAttribute("pacientes");
                                int pacientesConDiagnosticos = 0;
                                if (pacientes != null) {
                                    for (Paciente p : pacientes) {
                                        if (!p.getDiagnosticos().isEmpty()) {
                                            pacientesConDiagnosticos++;
                                        }
                                    }
                                }
                                %>
                                <% if (pacientesConDiagnosticos > 0) { %>
                                <a href="reportes?action=paciente" class="btn btn-success w-100">
                                    <i class="fas fa-user-check me-2"></i>Seleccionar Paciente
                                </a>
                                <% } else { %>
                                <button class="btn btn-secondary w-100" disabled>
                                    <i class="fas fa-exclamation-triangle me-2"></i>No hay pacientes con diagnósticos
                                </button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Estadísticas por Enfermedades -->
                    <div class="col-md-12">
                        <div class="card h-100 border-warning">
                            <div class="card-header bg-warning text-dark">
                                <h5 class="mb-0">
                                    <i class="fas fa-chart-pie me-2"></i>Estadísticas por Enfermedades
                                </h5>
                            </div>
                            <div class="card-body">
                                <p class="card-text">
                                    Visualice un resumen completo de todas las enfermedades diagnosticadas, 
                                    con estadísticas detalladas y la posibilidad de ver qué pacientes tienen cada enfermedad con sus porcentajes de probabilidad.
                                </p>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>Incluye:</h6>
                                        <ul class="list-unstyled">
                                            <li><i class="fas fa-check text-success me-2"></i>Lista completa de enfermedades</li>
                                            <li><i class="fas fa-check text-success me-2"></i>Total de casos por enfermedad</li>
                                            <li><i class="fas fa-check text-success me-2"></i>Casos exactos vs aproximados</li>
                                            <li><i class="fas fa-check text-success me-2"></i>Ranking de enfermedades más comunes</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>Funcionalidades:</h6>
                                        <ul class="list-unstyled">
                                            <li><i class="fas fa-check text-success me-2"></i>Ver pacientes por enfermedad</li>
                                            <li><i class="fas fa-check text-success me-2"></i>Porcentajes de probabilidad</li>
                                            <li><i class="fas fa-check text-success me-2"></i>Diagnósticos exactos y aproximados</li>
                                            <li><i class="fas fa-check text-success me-2"></i>Reportes imprimibles</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <a href="reportes?action=estadisticasEnfermedades" class="btn btn-warning w-100">
                                    <i class="fas fa-chart-bar me-2"></i>Ver Estadísticas de Enfermedades
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Estadísticas del sistema -->
                <div class="row mt-5">
                    <div class="col-12">
                        <div class="card border-info">
                            <div class="card-header bg-info text-white">
                                <h5 class="mb-0">
                                    <i class="fas fa-chart-bar me-2"></i>Estadísticas del Sistema
                                </h5>
                            </div>
                            <div class="card-body">
                                <%
                                int totalDiagnosticos = 0;
                                int diagnosticosExactos = 0;
                                if (pacientes != null) {
                                    for (Paciente p : pacientes) {
                                        totalDiagnosticos += p.getDiagnosticos().size();
                                        for (com.mycompany.diagnosticomedico2.model.Diagnostico d : p.getDiagnosticos()) {
                                            if (d.isEsExacto()) {
                                                diagnosticosExactos++;
                                            }
                                        }
                                    }
                                }
                                int diagnosticosAproximados = totalDiagnosticos - diagnosticosExactos;
                                %>
                                
                                <div class="row text-center">
                                    <div class="col-md-3">
                                        <div class="card border-primary">
                                            <div class="card-body">
                                                <h3 class="text-primary"><%= pacientes != null ? pacientes.size() : 0 %></h3>
                                                <p class="mb-0">Pacientes<br>Registrados</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card border-success">
                                            <div class="card-body">
                                                <h3 class="text-success"><%= totalDiagnosticos %></h3>
                                                <p class="mb-0">Diagnósticos<br>Realizados</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card border-warning">
                                            <div class="card-body">
                                                <h3 class="text-warning"><%= diagnosticosExactos %></h3>
                                                <p class="mb-0">Diagnósticos<br>Exactos</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card border-info">
                                            <div class="card-body">
                                                <h3 class="text-info"><%= diagnosticosAproximados %></h3>
                                                <p class="mb-0">Diagnósticos<br>Aproximados</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Información adicional -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card border-warning">
                            <div class="card-header bg-warning text-dark">
                                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Información de Reportes</h6>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled mb-0">
                                    <li><i class="fas fa-file-pdf text-danger me-2"></i>Los reportes se generan en formato PDF</li>
                                    <li><i class="fas fa-download text-primary me-2"></i>Se descargan automáticamente al navegador</li>
                                    <li><i class="fas fa-clock text-info me-2"></i>Incluyen fecha y hora de generación</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Contienen información completa y actualizada</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card border-secondary">
                            <div class="card-header bg-secondary text-white">
                                <h6 class="mb-0"><i class="fas fa-cogs me-2"></i>Acciones Adicionales</h6>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/diagnostico?action=historial" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-history me-2"></i>Ver Historial de Diagnósticos
                                    </a>
                                    <a href="${pageContext.request.contextPath}/pacientes" class="btn btn-outline-success btn-sm">
                                        <i class="fas fa-users me-2"></i>Gestionar Pacientes
                                    </a>
                                    <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-outline-warning btn-sm">
                                        <i class="fas fa-diagnoses me-2"></i>Realizar Nuevo Diagnóstico
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
