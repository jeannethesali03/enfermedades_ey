<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.mycompany.diagnosticomedico2.model.*"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte Médico del Paciente</title>
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
                line-height: 1.4;
            }
            h1 {
                font-size: 18pt;
            }
            h2, h3 {
                font-size: 14pt;
            }
            .page-break {
                page-break-before: always;
            }
        }
        .report-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 20px;
        }
        .patient-info {
            background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
            border-left: 4px solid #4caf50;
        }
        .diagnosis-card {
            background: linear-gradient(135deg, #fff3e0 0%, #ffcc02 20%, #fff3e0 100%);
            border-left: 4px solid #ff9800;
            margin-bottom: 20px;
        }
        .exact-diagnosis {
            background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
            border-left: 4px solid #4caf50;
        }
        .approximate-diagnosis {
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            border-left: 4px solid #ff9800;
        }
        .symptom-list {
            columns: 2;
            column-gap: 20px;
        }
        .confidence-bar {
            height: 8px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <%
        Paciente paciente = (Paciente) request.getAttribute("paciente");
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) request.getAttribute("sintomas");
        String fechaGeneracion = (String) request.getAttribute("fechaGeneracion");
    %>
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-body">
                <!-- Encabezado del reporte -->
                <div class="report-header">
                    <h1 class="text-primary">
                        <i class="fas fa-file-medical me-2"></i>
                        REPORTE MÉDICO DEL PACIENTE
                    </h1>
                    <p class="text-muted mb-0">
                        <i class="fas fa-calendar-alt me-1"></i>
                        Fecha de generación: <%= fechaGeneracion %>
                    </p>
                </div>

                <!-- Botones de acción -->
                <div class="mb-4 no-print">
                    <button onclick="window.print()" class="btn btn-primary">
                        <i class="fas fa-print me-1"></i> Imprimir Reporte
                    </button>
                    <a href="${pageContext.request.contextPath}/reportes?action=paciente" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Seleccionar Otro Paciente
                    </a>
                    <a href="${pageContext.request.contextPath}/reportes" class="btn btn-outline-secondary">
                        <i class="fas fa-home me-1"></i> Menú Principal
                    </a>
                </div>

                <!-- Información del paciente -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card patient-info">
                            <div class="card-header bg-success text-white">
                                <h2 class="mb-0">
                                    <i class="fas fa-user me-2"></i>
                                    INFORMACIÓN DEL PACIENTE
                                </h2>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="d-flex align-items-center mb-3">
                                            <i class="fas fa-id-card fa-2x text-primary me-3"></i>
                                            <div>
                                                <small class="text-muted">DUI del Paciente</small>
                                                <h4 class="mb-0 text-primary"><%= paciente.getId() %></h4>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="d-flex align-items-center mb-3">
                                            <i class="fas fa-user-circle fa-2x text-success me-3"></i>
                                            <div>
                                                <small class="text-muted">Nombre Completo</small>
                                                <h4 class="mb-0 text-dark"><%= paciente.getNombre() %></h4>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="d-flex align-items-center mb-3">
                                            <i class="fas fa-birthday-cake fa-2x text-warning me-3"></i>
                                            <div>
                                                <small class="text-muted">Edad</small>
                                                <h4 class="mb-0 text-dark"><%= paciente.getEdad() %> años</h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Historial de diagnósticos -->
                <div class="row">
                    <div class="col-12">
                        <h2 class="text-primary mb-4">
                            <i class="fas fa-notes-medical me-2"></i>
                            HISTORIAL DE DIAGNÓSTICOS
                        </h2>
                        
                        <% if (paciente.getDiagnosticos().isEmpty()) { %>
                            <div class="text-center py-5">
                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">No hay diagnósticos registrados</h4>
                                <p class="text-muted">Este paciente no tiene diagnósticos en su historial médico.</p>
                            </div>
                        <% } else { %>
                            <%
                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                                int diagnosticoNum = 1;
                                for (Diagnostico diagnostico : paciente.getDiagnosticos()) {
                            %>
                            <div class="diagnosis-card card mb-4">
                                <div class="card-header bg-primary text-white">
                                    <h3 class="mb-0">
                                        <i class="fas fa-notes-medical me-2"></i>
                                        DIAGNÓSTICO #<%= diagnosticoNum %> - <%= sdf.format(diagnostico.getFecha()) %>
                                    </h3>
                                </div>
                                <div class="card-body">
                                    <!-- Síntomas presentados -->
                                    <% if (diagnostico.getSintomasSeleccionados() != null && !diagnostico.getSintomasSeleccionados().isEmpty()) { %>
                                    <div class="mb-4">
                                        <h4 class="text-secondary mb-3">
                                            <i class="fas fa-stethoscope me-2"></i>
                                            Síntomas Presentados
                                        </h4>
                                        <div class="symptom-list">
                                            <%
                                                for (Integer sintomaId : diagnostico.getSintomasSeleccionados()) {
                                                    Sintoma sintoma = sintomas.stream()
                                                            .filter(s -> s.getId() == sintomaId)
                                                            .findFirst()
                                                            .orElse(null);
                                                    if (sintoma != null) {
                                            %>
                                            <div class="mb-2">
                                                <i class="fas fa-check-circle text-success me-2"></i>
                                                <strong><%= sintoma.getNombre() %></strong>
                                            </div>
                                            <%
                                                    }
                                                }
                                            %>
                                        </div>
                                    </div>
                                    <% } %>
                                    
                                    <!-- Resultado del diagnóstico -->
                                    <div class="row">
                                        <div class="col-12">
                                            <h4 class="text-secondary mb-3">
                                                <i class="fas fa-prescription-bottle-alt me-2"></i>
                                                Resultado del Diagnóstico
                                            </h4>
                                            
                                            <% if (diagnostico.isEsExacto()) { %>
                                            <div class="card exact-diagnosis">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center mb-3">
                                                        <i class="fas fa-bullseye fa-3x text-success me-3"></i>
                                                        <div>
                                                            <h5 class="text-success mb-1">DIAGNÓSTICO EXACTO</h5>
                                                            <h3 class="text-dark mb-0"><%= diagnostico.getEnfermedadDiagnosticada() %></h3>
                                                        </div>
                                                    </div>
                                                    <div class="mb-2">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <span class="fw-bold">Nivel de Confianza:</span>
                                                            <span class="badge bg-success fs-6">100%</span>
                                                        </div>
                                                        <div class="progress mt-1">
                                                            <div class="progress-bar bg-success" style="width: 100%"></div>
                                                        </div>
                                                    </div>
                                                    <p class="text-muted mb-0">
                                                        <i class="fas fa-info-circle me-1"></i>
                                                        Los síntomas coinciden exactamente con esta enfermedad.
                                                    </p>
                                                </div>
                                            </div>
                                            <% } else { %>
                                            <div class="card approximate-diagnosis">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center mb-3">
                                                        <i class="fas fa-search fa-3x text-warning me-3"></i>
                                                        <div>
                                                            <h5 class="text-warning mb-1">DIAGNÓSTICO APROXIMADO</h5>
                                                            <p class="text-muted mb-0">Posibles enfermedades basadas en los síntomas:</p>
                                                        </div>
                                                    </div>
                                                    
                                                    <% 
                                                        if (diagnostico.getResultadosAproximados() != null && !diagnostico.getResultadosAproximados().isEmpty()) {
                                                            for (ResultadoDiagnostico resultado : diagnostico.getResultadosAproximados()) {
                                                    %>
                                                    <div class="mb-3">
                                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                                            <h6 class="text-dark mb-0">
                                                                <i class="fas fa-virus me-2 text-primary"></i>
                                                                <%= resultado.getNombreEnfermedad() %>
                                                            </h6>
                                                            <span class="badge bg-warning text-dark">
                                                                <%= String.format("%.1f", resultado.getPorcentajeConfianza()) %>%
                                                            </span>
                                                        </div>
                                                        <div class="progress confidence-bar">
                                                            <div class="progress-bar bg-warning" 
                                                                 style="width: <%= resultado.getPorcentajeConfianza() %>%"></div>
                                                        </div>
                                                    </div>
                                                    <%
                                                            }
                                                        } else {
                                                    %>
                                                    <div class="alert alert-warning">
                                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                                        <%= diagnostico.getEnfermedadDiagnosticada() %>
                                                    </div>
                                                    <%
                                                        }
                                                    %>
                                                    
                                                    <div class="alert alert-info mt-3">
                                                        <i class="fas fa-lightbulb me-2"></i>
                                                        <strong>Recomendación:</strong> Se sugiere realizar estudios adicionales 
                                                        para confirmar el diagnóstico con mayor precisión.
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    diagnosticoNum++;
                                }
                            %>
                        <% } %>
                    </div>
                </div>

                <!-- Resumen final -->
                <% if (!paciente.getDiagnosticos().isEmpty()) { %>
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card border-primary">
                            <div class="card-header bg-primary text-white">
                                <h4 class="mb-0">
                                    <i class="fas fa-chart-line me-2"></i>
                                    RESUMEN DEL HISTORIAL MÉDICO
                                </h4>
                            </div>
                            <div class="card-body">
                                <div class="row text-center">
                                    <div class="col-md-4">
                                        <i class="fas fa-notes-medical fa-2x text-primary mb-2"></i>
                                        <h4 class="text-primary"><%= paciente.getDiagnosticos().size() %></h4>
                                        <p class="text-muted mb-0">Total de Diagnósticos</p>
                                    </div>
                                    <div class="col-md-4">
                                        <i class="fas fa-bullseye fa-2x text-success mb-2"></i>
                                        <%
                                            long exactos = paciente.getDiagnosticos().stream()
                                                    .mapToLong(d -> d.isEsExacto() ? 1 : 0)
                                                    .sum();
                                        %>
                                        <h4 class="text-success"><%= exactos %></h4>
                                        <p class="text-muted mb-0">Diagnósticos Exactos</p>
                                    </div>
                                    <div class="col-md-4">
                                        <i class="fas fa-search fa-2x text-warning mb-2"></i>
                                        <h4 class="text-warning"><%= paciente.getDiagnosticos().size() - exactos %></h4>
                                        <p class="text-muted mb-0">Diagnósticos Aproximados</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
