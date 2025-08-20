<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.*" %>
<%@ page import="com.mycompany.diagnosticomedico2.servlet.ReporteServlet.PacienteDiagnosticoDetalle" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pacientes con Enfermedad - Sistema Diagnóstico Médico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .disease-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            border-radius: 10px 10px 0 0;
        }
        
        .patient-row {
            transition: background-color 0.2s;
        }
        
        .patient-row:hover {
            background-color: #f8f9fa;
        }
        
        .percentage-badge {
            font-size: 1em;
            min-width: 60px;
        }
        
        .percentage-excellent {
            background-color: #28a745;
        }
        
        .percentage-good {
            background-color: #ffc107;
            color: #212529;
        }
        
        .percentage-fair {
            background-color: #fd7e14;
        }
        
        .percentage-poor {
            background-color: #dc3545;
        }
        
        @media print {
            .no-print {
                display: none !important;
            }
            .card {
                border: 1px solid #dee2e6 !important;
                box-shadow: none !important;
            }
            .disease-header {
                background: #17a2b8 !important;
                -webkit-print-color-adjust: exact;
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

    <%
    String enfermedadNombre = (String) request.getAttribute("enfermedadNombre");
    @SuppressWarnings("unchecked")
    List<PacienteDiagnosticoDetalle> pacientesConEnfermedad = (List<PacienteDiagnosticoDetalle>) request.getAttribute("pacientesConEnfermedad");
    String fechaGeneracion = (String) request.getAttribute("fechaGeneracion");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
    
    if (pacientesConEnfermedad == null) pacientesConEnfermedad = new java.util.ArrayList<>();
    
    // Calcular estadísticas
    int totalPacientes = pacientesConEnfermedad.size();
    int casosExactos = 0;
    int casosAproximados = 0;
    double porcentajePromedio = 0;
    
    for (PacienteDiagnosticoDetalle detalle : pacientesConEnfermedad) {
        if (detalle.getDiagnostico().isEsExacto()) {
            casosExactos++;
        } else {
            casosAproximados++;
        }
        porcentajePromedio += detalle.getPorcentaje();
    }
    
    if (totalPacientes > 0) {
        porcentajePromedio /= totalPacientes;
    }
    %>

    <div class="container mt-4">
        <!-- Encabezado -->
        <div class="card mb-4 border-0 shadow">
            <div class="disease-header p-4">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="d-flex align-items-center">
                            <div class="me-4">
                                <i class="fas fa-users fa-4x"></i>
                            </div>
                            <div>
                                <h2 class="mb-1">Pacientes con <%= enfermedadNombre %></h2>
                                <p class="mb-0 opacity-75">
                                    <i class="fas fa-users me-2"></i><%= totalPacientes %> paciente<%= totalPacientes != 1 ? "s" : "" %> diagnosticado<%= totalPacientes != 1 ? "s" : "" %>
                                    <span class="mx-3">|</span>
                                    <i class="fas fa-calendar me-2"></i><%= fechaGeneracion %>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="btn-group no-print" role="group">
                            <button onclick="window.print()" class="btn btn-light">
                                <i class="fas fa-print me-1"></i> Imprimir
                            </button>
                            <a href="reportes?action=estadisticasEnfermedades" class="btn btn-outline-light">
                                <i class="fas fa-chart-pie me-1"></i> Estadísticas
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Estadísticas resumidas -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card border-primary">
                    <div class="card-body text-center">
                        <i class="fas fa-users fa-2x text-primary mb-2"></i>
                        <h4 class="text-primary"><%= totalPacientes %></h4>
                        <p class="mb-0">Total<br>Pacientes</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-success">
                    <div class="card-body text-center">
                        <i class="fas fa-bullseye fa-2x text-success mb-2"></i>
                        <h4 class="text-success"><%= casosExactos %></h4>
                        <p class="mb-0">Diagnósticos<br>Exactos (100%)</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-warning">
                    <div class="card-body text-center">
                        <i class="fas fa-search fa-2x text-warning mb-2"></i>
                        <h4 class="text-warning"><%= casosAproximados %></h4>
                        <p class="mb-0">Diagnósticos<br>Aproximados</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-info">
                    <div class="card-body text-center">
                        <i class="fas fa-percentage fa-2x text-info mb-2"></i>
                        <h4 class="text-info"><%= String.format("%.1f", porcentajePromedio) %>%</h4>
                        <p class="mb-0">Probabilidad<br>Promedio</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lista de pacientes -->
        <div class="card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0">
                    <i class="fas fa-list me-2"></i>Lista Detallada de Pacientes
                </h5>
            </div>
            <div class="card-body p-0">
                <% if (!pacientesConEnfermedad.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Paciente</th>
                                <th>DUI</th>
                                <th>Edad</th>
                                <th>Fecha Diagnóstico</th>
                                <th>Hora</th>
                                <th>Probabilidad</th>
                                <th>Tipo Diagnóstico</th>
                                <th class="no-print">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            int contador = 1;
                            for (PacienteDiagnosticoDetalle detalle : pacientesConEnfermedad) {
                                Paciente paciente = detalle.getPaciente();
                                Diagnostico diagnostico = detalle.getDiagnostico();
                                double porcentaje = detalle.getPorcentaje();
                                
                                String badgeClass = "percentage-excellent";
                                if (porcentaje < 50) badgeClass = "percentage-poor";
                                else if (porcentaje < 70) badgeClass = "percentage-fair";
                                else if (porcentaje < 100) badgeClass = "percentage-good";
                            %>
                            <tr class="patient-row">
                                <td><strong><%= contador++ %></strong></td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-user-circle fa-lg text-primary me-2"></i>
                                        <div>
                                            <strong><%= paciente.getNombre() %></strong>
                                        </div>
                                    </div>
                                </td>
                                <td><code><%= paciente.getId() %></code></td>
                                <td>
                                    <span class="badge bg-light text-dark">
                                        <%= paciente.getEdad() %> años
                                    </span>
                                </td>
                                <td><%= sdf.format(diagnostico.getFecha()) %></td>
                                <td><%= sdfHora.format(diagnostico.getFecha()) %></td>
                                <td>
                                    <span class="badge <%= badgeClass %> percentage-badge">
                                        <%= String.format("%.1f", porcentaje) %>%
                                    </span>
                                </td>
                                <td>
                                    <% if (diagnostico.isEsExacto()) { %>
                                    <span class="badge bg-success">
                                        <i class="fas fa-bullseye me-1"></i>Exacto
                                    </span>
                                    <% } else { %>
                                    <span class="badge bg-warning">
                                        <i class="fas fa-search me-1"></i>Aproximado
                                    </span>
                                    <% } %>
                                </td>
                                <td class="no-print">
                                    <div class="btn-group btn-group-sm">
                                        <a href="pacientes?action=view&id=<%= paciente.getId() %>" 
                                           class="btn btn-outline-info" title="Ver paciente">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="reportes?action=paciente&pacienteId=<%= paciente.getId() %>" 
                                           class="btn btn-outline-success" title="Reporte del paciente">
                                            <i class="fas fa-file-alt"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="text-center py-5">
                    <i class="fas fa-info-circle fa-3x text-muted mb-3"></i>
                    <h5 class="text-muted">No hay pacientes diagnosticados</h5>
                    <p class="text-muted">Esta enfermedad no ha sido diagnosticada en ningún paciente</p>
                    <a href="reportes?action=estadisticasEnfermedades" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-2"></i>Volver a Estadísticas
                    </a>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Análisis de distribución -->
        <% if (totalPacientes > 0) { %>
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card border-info">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-chart-pie me-2"></i>Distribución de Probabilidades
                        </h6>
                    </div>
                    <div class="card-body">
                        <%
                        int excelentes = 0, buenos = 0, regulares = 0, pobres = 0;
                        for (PacienteDiagnosticoDetalle detalle : pacientesConEnfermedad) {
                            double p = detalle.getPorcentaje();
                            if (p == 100) excelentes++;
                            else if (p >= 70) buenos++;
                            else if (p >= 50) regulares++;
                            else pobres++;
                        }
                        %>
                        
                        <div class="mb-2">
                            <div class="d-flex justify-content-between">
                                <span><span class="badge percentage-excellent">100%</span> Exactos:</span>
                                <span class="fw-bold"><%= excelentes %></span>
                            </div>
                        </div>
                        <div class="mb-2">
                            <div class="d-flex justify-content-between">
                                <span><span class="badge percentage-good">70-99%</span> Buenos:</span>
                                <span class="fw-bold"><%= buenos %></span>
                            </div>
                        </div>
                        <div class="mb-2">
                            <div class="d-flex justify-content-between">
                                <span><span class="badge percentage-fair">50-69%</span> Regulares:</span>
                                <span class="fw-bold"><%= regulares %></span>
                            </div>
                        </div>
                        <div class="mb-2">
                            <div class="d-flex justify-content-between">
                                <span><span class="badge percentage-poor">&lt;50%</span> Pobres:</span>
                                <span class="fw-bold"><%= pobres %></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-warning">
                    <div class="card-header bg-warning text-dark">
                        <h6 class="mb-0">
                            <i class="fas fa-info-circle me-2"></i>Interpretación
                        </h6>
                    </div>
                    <div class="card-body">
                        <h6>Significado de Probabilidades:</h6>
                        <ul class="list-unstyled">
                            <li><i class="fas fa-circle text-success me-2"></i><strong>100%:</strong> Diagnóstico exacto (todos los síntomas coinciden)</li>
                            <li><i class="fas fa-circle text-warning me-2"></i><strong>70-99%:</strong> Alta probabilidad (buena coincidencia)</li>
                            <li><i class="fas fa-circle" style="color: #fd7e14;" me-2></i><strong>50-69%:</strong> Probabilidad moderada</li>
                            <li><i class="fas fa-circle text-danger me-2"></i><strong>&lt;50%:</strong> Baja probabilidad (requiere revisión)</li>
                        </ul>
                        
                        <hr>
                        
                        <h6>Promedio General:</h6>
                        <div class="progress" style="height: 25px;">
                            <div class="progress-bar bg-info" style="width: <%= porcentajePromedio %>%">
                                <%= String.format("%.1f", porcentajePromedio) %>%
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Acciones -->
        <div class="row mt-4 no-print">
            <div class="col-12">
                <div class="card border-secondary">
                    <div class="card-header bg-secondary text-white">
                        <h6 class="mb-0"><i class="fas fa-cogs me-2"></i>Acciones</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex gap-2 flex-wrap">
                            <button onclick="window.print()" class="btn btn-primary">
                                <i class="fas fa-print me-2"></i>Imprimir Reporte
                            </button>
                            <a href="reportes?action=estadisticasEnfermedades" class="btn btn-outline-warning">
                                <i class="fas fa-chart-pie me-2"></i>Ver Todas las Estadísticas
                            </a>
                            <a href="reportes?action=global" class="btn btn-outline-primary">
                                <i class="fas fa-globe me-2"></i>Reporte Global
                            </a>
                            <a href="reportes" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Volver a Reportes
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
