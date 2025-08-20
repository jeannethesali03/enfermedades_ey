<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.mycompany.diagnosticomedico2.model.*"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte Global de Diagnósticos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        @media print {
            .no-print {
                display: none !important;
            }
            .container {
                max-width: none !important;
                margin: 0 !important;
                padding: 0 !important;
            }
            .card {
                border: none !important;
                box-shadow: none !important;
            }
            body {
                font-size: 12pt;
            }
            h1 {
                font-size: 18pt;
            }
            h2, h3 {
                font-size: 14pt;
            }
        }
        .report-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 20px;
        }
        .stats-card {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-left: 4px solid #2196f3;
        }
        .table-responsive {
            max-height: 400px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="card">
            <div class="card-body">
                <!-- Encabezado del reporte -->
                <div class="report-header">
                    <h1 class="text-primary">
                        <i class="fas fa-chart-bar me-2"></i>
                        REPORTE GLOBAL DE DIAGNÓSTICOS MÉDICOS
                    </h1>
                    <p class="text-muted mb-0">
                        <i class="fas fa-calendar-alt me-1"></i>
                        Fecha de generación: ${fechaGeneracion}
                    </p>
                </div>

                <!-- Botones de acción -->
                <div class="mb-4 no-print">
                    <button onclick="window.print()" class="btn btn-primary">
                        <i class="fas fa-print me-1"></i> Imprimir Reporte
                    </button>
                    <a href="${pageContext.request.contextPath}/reportes" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Volver al Menú
                    </a>
                </div>

                <!-- Resumen general -->
                <div class="row mb-4">
                    <div class="col-12">
                        <h2 class="text-primary mb-3">
                            <i class="fas fa-info-circle me-2"></i>
                            RESUMEN GENERAL
                        </h2>
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-stethoscope fa-2x text-primary mb-2"></i>
                                <h4 class="card-title text-primary">${sintomas.size()}</h4>
                                <p class="card-text">Síntomas Registrados</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-virus fa-2x text-danger mb-2"></i>
                                <h4 class="card-title text-danger">${enfermedades.size()}</h4>
                                <p class="card-text">Enfermedades Registradas</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-users fa-2x text-success mb-2"></i>
                                <h4 class="card-title text-success">${pacientes.size()}</h4>
                                <p class="card-text">Pacientes Registrados</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card h-100">
                            <div class="card-body text-center">
                                <i class="fas fa-notes-medical fa-2x text-warning mb-2"></i>
                                <h4 class="card-title text-warning">${totalDiagnosticos}</h4>
                                <p class="card-text">Diagnósticos Realizados</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Estadísticas de diagnósticos -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">
                                    <i class="fas fa-chart-pie me-2"></i>
                                    Tipos de Diagnósticos
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-2">
                                    <div class="d-flex justify-content-between">
                                        <span>Diagnósticos Exactos:</span>
                                        <strong class="text-success">${diagnosticosExactos}</strong>
                                    </div>
                                    <div class="progress mb-2">
                                        <div class="progress-bar bg-success" style="width: ${totalDiagnosticos > 0 ? (diagnosticosExactos * 100.0 / totalDiagnosticos) : 0}%"></div>
                                    </div>
                                </div>
                                <div class="mb-2">
                                    <div class="d-flex justify-content-between">
                                        <span>Diagnósticos Aproximados:</span>
                                        <strong class="text-warning">${diagnosticosAproximados}</strong>
                                    </div>
                                    <div class="progress">
                                        <div class="progress-bar bg-warning" style="width: ${totalDiagnosticos > 0 ? (diagnosticosAproximados * 100.0 / totalDiagnosticos) : 0}%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header bg-info text-white">
                                <h5 class="mb-0">
                                    <i class="fas fa-trophy me-2"></i>
                                    Enfermedades Más Diagnosticadas
                                </h5>
                            </div>
                            <div class="card-body">
                                <%
                                    @SuppressWarnings("unchecked")
                                    List<Map.Entry<String, Integer>> enfermedadesOrdenadas = 
                                        (List<Map.Entry<String, Integer>>) request.getAttribute("enfermedadesOrdenadas");
                                    
                                    if (enfermedadesOrdenadas != null && !enfermedadesOrdenadas.isEmpty()) {
                                        int maxCount = enfermedadesOrdenadas.get(0).getValue();
                                        for (int i = 0; i < Math.min(5, enfermedadesOrdenadas.size()); i++) {
                                            Map.Entry<String, Integer> entry = enfermedadesOrdenadas.get(i);
                                            double percentage = (entry.getValue() * 100.0) / maxCount;
                                %>
                                <div class="mb-2">
                                    <div class="d-flex justify-content-between">
                                        <span class="text-truncate" title="<%= entry.getKey() %>"><%= entry.getKey() %></span>
                                        <strong class="text-primary"><%= entry.getValue() %> caso(s)</strong>
                                    </div>
                                    <div class="progress progress-sm">
                                        <div class="progress-bar bg-primary" style="width: <%= percentage %>%"></div>
                                    </div>
                                </div>
                                <%
                                        }
                                    } else {
                                %>
                                <p class="text-muted mb-0">No hay estadísticas disponibles</p>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabla de diagnósticos por paciente -->
                <% if ((Integer) request.getAttribute("totalDiagnosticos") > 0) { %>
                <div class="row">
                    <div class="col-12">
                        <h3 class="text-primary mb-3">
                            <i class="fas fa-table me-2"></i>
                            DIAGNÓSTICOS REALIZADOS
                        </h3>
                        
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th><i class="fas fa-user me-1"></i> Paciente</th>
                                        <th><i class="fas fa-birthday-cake me-1"></i> Edad</th>
                                        <th><i class="fas fa-calendar me-1"></i> Fecha</th>
                                        <th><i class="fas fa-tag me-1"></i> Tipo</th>
                                        <th><i class="fas fa-notes-medical me-1"></i> Diagnóstico</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        @SuppressWarnings("unchecked")
                                        List<Paciente> pacientes = (List<Paciente>) request.getAttribute("pacientes");
                                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                        
                                        for (Paciente paciente : pacientes) {
                                            for (Diagnostico diagnostico : paciente.getDiagnosticos()) {
                                    %>
                                    <tr>
                                        <td>
                                            <strong><%= paciente.getNombre() %></strong>
                                            <br><small class="text-muted">DUI: <%= paciente.getId() %></small>
                                        </td>
                                        <td><%= paciente.getEdad() %> años</td>
                                        <td><%= sdf.format(diagnostico.getFecha()) %></td>
                                        <td>
                                            <% if (diagnostico.isEsExacto()) { %>
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check-circle me-1"></i>Exacto
                                                </span>
                                            <% } else { %>
                                                <span class="badge bg-warning">
                                                    <i class="fas fa-question-circle me-1"></i>Aproximado
                                                </span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (diagnostico.isEsExacto()) { %>
                                                <strong class="text-success"><%= diagnostico.getEnfermedadDiagnosticada() %></strong>
                                                <br><small class="text-muted">Confianza: 100%</small>
                                            <% } else { %>
                                                <% 
                                                    if (diagnostico.getResultadosAproximados() != null && !diagnostico.getResultadosAproximados().isEmpty()) {
                                                        for (ResultadoDiagnostico resultado : diagnostico.getResultadosAproximados()) {
                                                %>
                                                    <div class="mb-1">
                                                        <span class="text-primary"><%= resultado.getNombreEnfermedad() %></span>
                                                        <small class="text-muted">(<%= String.format("%.1f", resultado.getPorcentajeConfianza()) %>%)</small>
                                                    </div>
                                                <%
                                                        }
                                                    } else {
                                                %>
                                                    <%= diagnostico.getEnfermedadDiagnosticada() %>
                                                <%
                                                    }
                                                %>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <div class="text-center py-5">
                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                    <h4 class="text-muted">No hay diagnósticos registrados en el sistema</h4>
                    <p class="text-muted">Registre pacientes y realice diagnósticos para generar reportes.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
