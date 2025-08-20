<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.mycompany.diagnosticomedico2.servlet.ReporteServlet.EnfermedadEstadistica" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estadísticas por Enfermedades - Sistema Diagnóstico Médico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .stats-card {
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-2px);
        }
        
        .disease-row {
            transition: background-color 0.2s;
        }
        
        .disease-row:hover {
            background-color: #f8f9fa;
        }
        
        .progress-exact {
            background-color: #28a745;
        }
        
        .progress-approximate {
            background-color: #ffc107;
        }
        
        @media print {
            .no-print {
                display: none !important;
            }
            .card {
                border: 1px solid #dee2e6 !important;
                box-shadow: none !important;
            }
        }
    </style>
</head>
<body>
    <!-- Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary no-print">
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
        <!-- Encabezado del reporte -->
        <div class="text-center mb-4">
            <h2><i class="fas fa-chart-pie me-2"></i>Estadísticas por Enfermedades</h2>
            <p class="text-muted">Análisis completo de enfermedades diagnosticadas en el sistema</p>
            <small class="text-muted">Generado el: <%= request.getAttribute("fechaGeneracion") %></small>
        </div>

        <%
        @SuppressWarnings("unchecked")
        List<EnfermedadEstadistica> estadisticas = (List<EnfermedadEstadistica>) request.getAttribute("estadisticasEnfermedades");
        
        // Calcular totales generales
        int totalCasos = 0;
        int totalExactos = 0;
        int totalAproximados = 0;
        int enfermedadesConCasos = 0;
        
        if (estadisticas != null) {
            for (EnfermedadEstadistica stat : estadisticas) {
                if (stat.getTotalCasos() > 0) {
                    enfermedadesConCasos++;
                    totalCasos += stat.getTotalCasos();
                    totalExactos += stat.getCasosExactos();
                    totalAproximados += stat.getCasosAproximados();
                }
            }
        }
        %>

        <!-- Resumen general -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card border-primary">
                    <div class="card-body text-center">
                        <i class="fas fa-virus fa-2x text-primary mb-2"></i>
                        <h4 class="text-primary"><%= enfermedadesConCasos %></h4>
                        <p class="mb-0">Enfermedades<br>Diagnosticadas</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-success">
                    <div class="card-body text-center">
                        <i class="fas fa-notes-medical fa-2x text-success mb-2"></i>
                        <h4 class="text-success"><%= totalCasos %></h4>
                        <p class="mb-0">Total de<br>Casos</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-warning">
                    <div class="card-body text-center">
                        <i class="fas fa-bullseye fa-2x text-warning mb-2"></i>
                        <h4 class="text-warning"><%= totalExactos %></h4>
                        <p class="mb-0">Diagnósticos<br>Exactos</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-info">
                    <div class="card-body text-center">
                        <i class="fas fa-search fa-2x text-info mb-2"></i>
                        <h4 class="text-info"><%= totalAproximados %></h4>
                        <p class="mb-0">Diagnósticos<br>Aproximados</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de estadísticas por enfermedad -->
        <div class="card">
            <div class="card-header bg-light">
                <h5 class="mb-0">
                    <i class="fas fa-table me-2"></i>Detalle por Enfermedad
                </h5>
            </div>
            <div class="card-body p-0">
                <% if (estadisticas != null && !estadisticas.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>#</th>
                                <th>Enfermedad</th>
                                <th>Total Casos</th>
                                <th>Exactos</th>
                                <th>Aproximados</th>
                                <th>% Exactitud</th>
                                <th>Distribución</th>
                                <th class="no-print">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            int contador = 1;
                            for (EnfermedadEstadistica stat : estadisticas) { 
                                if (stat.getTotalCasos() > 0) {
                                    double porcentajeExactitud = stat.getTotalCasos() > 0 ? 
                                        (double) stat.getCasosExactos() / stat.getTotalCasos() * 100 : 0;
                            %>
                            <tr class="disease-row">
                                <td><strong><%= contador++ %></strong></td>
                                <td>
                                    <i class="fas fa-virus text-danger me-2"></i>
                                    <strong><%= stat.getNombre() %></strong>
                                </td>
                                <td>
                                    <span class="badge bg-primary fs-6">
                                        <%= stat.getTotalCasos() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-success">
                                        <%= stat.getCasosExactos() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-warning">
                                        <%= stat.getCasosAproximados() %>
                                    </span>
                                </td>
                                <td>
                                    <strong class="<%= porcentajeExactitud >= 70 ? "text-success" : porcentajeExactitud >= 50 ? "text-warning" : "text-danger" %>">
                                        <%= String.format("%.1f", porcentajeExactitud) %>%
                                    </strong>
                                </td>
                                <td style="width: 200px;">
                                    <div class="progress" style="height: 20px;">
                                        <% if (stat.getCasosExactos() > 0) { %>
                                        <div class="progress-bar progress-exact" 
                                             style="width: <%= (double) stat.getCasosExactos() / stat.getTotalCasos() * 100 %>%"
                                             title="Exactos: <%= stat.getCasosExactos() %>">
                                        </div>
                                        <% } %>
                                        <% if (stat.getCasosAproximados() > 0) { %>
                                        <div class="progress-bar progress-approximate" 
                                             style="width: <%= (double) stat.getCasosAproximados() / stat.getTotalCasos() * 100 %>%"
                                             title="Aproximados: <%= stat.getCasosAproximados() %>">
                                        </div>
                                        <% } %>
                                    </div>
                                    <small class="text-muted">
                                        <%= stat.getCasosExactos() %> exactos, <%= stat.getCasosAproximados() %> aproximados
                                    </small>
                                </td>
                                <td class="no-print">
                                    <a href="reportes?action=pacientesEnfermedad&enfermedadNombre=<%= java.net.URLEncoder.encode(stat.getNombre(), "UTF-8") %>" 
                                       class="btn btn-sm btn-outline-info">
                                        <i class="fas fa-users me-1"></i>Ver Pacientes
                                    </a>
                                </td>
                            </tr>
                            <% 
                                }
                            } 
                            %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="text-center py-5">
                    <i class="fas fa-info-circle fa-3x text-muted mb-3"></i>
                    <h5 class="text-muted">No hay enfermedades diagnosticadas</h5>
                    <p class="text-muted">Realice algunos diagnósticos para ver las estadísticas</p>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Acciones del reporte -->
        <div class="row mt-4 no-print">
            <div class="col-12">
                <div class="card border-secondary">
                    <div class="card-header bg-secondary text-white">
                        <h6 class="mb-0"><i class="fas fa-cogs me-2"></i>Acciones del Reporte</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex gap-2 flex-wrap">
                            <button onclick="window.print()" class="btn btn-primary">
                                <i class="fas fa-print me-2"></i>Imprimir Reporte
                            </button>
                            <a href="reportes?action=global" class="btn btn-outline-primary">
                                <i class="fas fa-globe me-2"></i>Reporte Global
                            </a>
                            <a href="reportes?action=paciente" class="btn btn-outline-success">
                                <i class="fas fa-user-md me-2"></i>Reporte por Paciente
                            </a>
                            <a href="reportes" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Volver a Reportes
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Información adicional -->
        <div class="row mt-3 no-print">
            <div class="col-12">
                <div class="card border-info">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Información del Reporte</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Explicación de Estadísticas:</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-circle text-success me-2"></i><strong>Exactos:</strong> Diagnósticos donde todos los síntomas coinciden</li>
                                    <li><i class="fas fa-circle text-warning me-2"></i><strong>Aproximados:</strong> Diagnósticos basados en coincidencia parcial</li>
                                    <li><i class="fas fa-circle text-primary me-2"></i><strong>% Exactitud:</strong> Porcentaje de diagnósticos exactos sobre el total</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6>Interpretación de Colores:</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-circle text-success me-2"></i><strong>Verde:</strong> Exactitud ≥ 70% (Excelente)</li>
                                    <li><i class="fas fa-circle text-warning me-2"></i><strong>Amarillo:</strong> Exactitud 50-69% (Bueno)</li>
                                    <li><i class="fas fa-circle text-danger me-2"></i><strong>Rojo:</strong> Exactitud < 50% (Requiere atención)</li>
                                </ul>
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
