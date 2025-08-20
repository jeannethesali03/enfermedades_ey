<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.*" %>
<%@ page import="com.mycompany.diagnosticomedico2.servlet.ReporteServlet.PacienteDiagnostico" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte por Enfermedad - Sistema Diagnóstico Médico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .disease-header {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border-radius: 10px 10px 0 0;
        }
        
        .stats-card {
            transition: transform 0.2s;
        }
        
        .stats-card:hover {
            transform: translateY(-2px);
        }
        
        .patient-row {
            transition: background-color 0.2s;
        }
        
        .patient-row:hover {
            background-color: #f8f9fa;
        }
        
        .diagnosis-badge {
            font-size: 0.9em;
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
                background: #dc3545 !important;
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
    Enfermedad enfermedad = (Enfermedad) request.getAttribute("enfermedad");
    String enfermedadNombre = (String) request.getAttribute("enfermedadNombre");
    @SuppressWarnings("unchecked")
    List<PacienteDiagnostico> pacientesConEnfermedad = (List<PacienteDiagnostico>) request.getAttribute("pacientesConEnfermedad");
    @SuppressWarnings("unchecked")
    List<Sintoma> sintomas = (List<Sintoma>) request.getAttribute("sintomas");
    Integer casosExactos = (Integer) request.getAttribute("casosExactos");
    Integer casosAproximados = (Integer) request.getAttribute("casosAproximados");
    Integer totalCasos = (Integer) request.getAttribute("totalCasos");
    String fechaGeneracion = (String) request.getAttribute("fechaGeneracion");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
    
    if (casosExactos == null) casosExactos = 0;
    if (casosAproximados == null) casosAproximados = 0;
    if (totalCasos == null) totalCasos = 0;
    if (sintomas == null) sintomas = new ArrayList<>();
    
    double porcentajeExactitud = totalCasos > 0 ? (double) casosExactos / totalCasos * 100 : 0;
    %>

    <div class="container mt-4">
        <!-- Encabezado de la enfermedad -->
        <div class="card mb-4 border-0 shadow">
            <div class="disease-header p-4">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="d-flex align-items-center">
                            <div class="me-4">
                                <i class="fas fa-virus fa-4x"></i>
                            </div>
                            <div>
                                <h2 class="mb-1"><%= enfermedadNombre %></h2>
                                <p class="mb-0 opacity-75">
                                    <i class="fas fa-notes-medical me-2"></i>Reporte Detallado de Enfermedad
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
            
            <!-- Información de la enfermedad (si está disponible) -->
            <% if (enfermedad != null) { %>
            <div class="card-body bg-light">
                <div class="row">
                    <div class="col-md-8">
                        <h6><i class="fas fa-list-ul me-2"></i>Síntomas Asociados:</h6>
                        <div class="d-flex flex-wrap gap-2">
                            <% for (String sintoma : enfermedad.getSintomas()) { %>
                            <span class="badge bg-secondary fs-6">
                                <i class="fas fa-thermometer-half me-1"></i><%= sintoma %>
                            </span>
                            <% } %>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <h6><i class="fas fa-info-circle me-2"></i>Información Adicional:</h6>
                        <p class="mb-0 text-muted">
                            <small>Total de síntomas definidos: <%= enfermedad.getSintomas().size() %></small>
                        </p>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        
        <!-- Estadísticas de la enfermedad -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card border-primary">
                    <div class="card-body text-center">
                        <i class="fas fa-users fa-2x text-primary mb-2"></i>
                        <h4 class="text-primary"><%= totalCasos %></h4>
                        <p class="mb-0">Total<br>Pacientes</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-success">
                    <div class="card-body text-center">
                        <i class="fas fa-bullseye fa-2x text-success mb-2"></i>
                        <h4 class="text-success"><%= casosExactos %></h4>
                        <p class="mb-0">Diagnósticos<br>Exactos</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-warning">
                    <div class="card-body text-center">
                        <i class="fas fa-search fa-2x text-warning mb-2"></i>
                        <h4 class="text-warning"><%= casosAproximados %></h4>
                        <p class="mb-0">Diagnósticos<br>Aproximados</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-info">
                    <div class="card-body text-center">
                        <i class="fas fa-percentage fa-2x text-info mb-2"></i>
                        <h4 class="text-info"><%= String.format("%.1f", porcentajeExactitud) %>%</h4>
                        <p class="mb-0">Exactitud<br>Diagnóstica</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lista detallada de pacientes -->
        <div class="card">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0">
                    <i class="fas fa-list me-2"></i>Pacientes Diagnosticados con <%= enfermedadNombre %>
                </h5>
            </div>
            <div class="card-body p-0">
                <% if (pacientesConEnfermedad != null && !pacientesConEnfermedad.isEmpty()) { %>
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
                                <th>Tipo</th>
                                <th>Síntomas Presentados</th>
                                <th class="no-print">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            int contador = 1;
                            for (PacienteDiagnostico pd : pacientesConEnfermedad) {
                                Paciente paciente = pd.getPaciente();
                                Diagnostico diagnostico = pd.getDiagnostico();
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
                                    <% if (diagnostico.isEsExacto()) { %>
                                    <span class="badge bg-success diagnosis-badge">
                                        <i class="fas fa-bullseye me-1"></i>Exacto
                                    </span>
                                    <% } else { %>
                                    <span class="badge bg-warning diagnosis-badge">
                                        <i class="fas fa-search me-1"></i>Aproximado
                                    </span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="d-flex flex-wrap gap-1">
                                        <% 
                                        List<Integer> sintomasSeleccionados = diagnostico.getSintomasSeleccionados();
                                        if (sintomasSeleccionados != null && !sintomasSeleccionados.isEmpty()) {
                                            for (Integer sintomaId : sintomasSeleccionados) {
                                                // Buscar el nombre del síntoma por ID
                                                String nombreSintoma = "Síntoma " + sintomaId;
                                                if (sintomas != null) {
                                                    for (Sintoma s : sintomas) {
                                                        if (s.getId() == sintomaId) {
                                                            nombreSintoma = s.getNombre();
                                                            break;
                                                        }
                                                    }
                                                }
                                        %>
                                        <span class="badge bg-secondary" title="<%= nombreSintoma %>">
                                            <%= nombreSintoma.length() > 15 ? nombreSintoma.substring(0, 15) + "..." : nombreSintoma %>
                                        </span>
                                        <% 
                                            }
                                        } else {
                                        %>
                                        <span class="text-muted">Sin síntomas registrados</span>
                                        <% } %>
                                    </div>
                                    <small class="text-muted">
                                        <%= sintomasSeleccionados != null ? sintomasSeleccionados.size() : 0 %> síntomas
                                    </small>
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
                </div>
                <% } %>
            </div>
        </div>

        <!-- Análisis adicional -->
        <% if (totalCasos > 0) { %>
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card border-info">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-chart-bar me-2"></i>Análisis de Distribución
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">Distribución de Diagnósticos:</label>
                            <div class="progress" style="height: 25px;">
                                <% if (casosExactos > 0) { %>
                                <div class="progress-bar bg-success" style="width: <%= porcentajeExactitud %>%">
                                    <%= casosExactos %> Exactos (<%= String.format("%.1f", porcentajeExactitud) %>%)
                                </div>
                                <% } %>
                                <% if (casosAproximados > 0) { %>
                                <div class="progress-bar bg-warning" style="width: <%= 100 - porcentajeExactitud %>%">
                                    <%= casosAproximados %> Aproximados (<%= String.format("%.1f", 100 - porcentajeExactitud) %>%)
                                </div>
                                <% } %>
                            </div>
                        </div>
                        
                        <%
                        // Análisis de edades
                        java.util.Map<String, Integer> rangoEdades = new java.util.HashMap<>();
                        for (PacienteDiagnostico pd : pacientesConEnfermedad) {
                            int edad = pd.getPaciente().getEdad();
                            String rango;
                            if (edad < 18) rango = "Menores de 18";
                            else if (edad < 30) rango = "18-29 años";
                            else if (edad < 50) rango = "30-49 años";
                            else if (edad < 65) rango = "50-64 años";
                            else rango = "65+ años";
                            rangoEdades.merge(rango, 1, Integer::sum);
                        }
                        %>
                        
                        <label class="form-label">Distribución por Edad:</label>
                        <% for (java.util.Map.Entry<String, Integer> entry : rangoEdades.entrySet()) { %>
                        <div class="d-flex justify-content-between">
                            <span><%= entry.getKey() %>:</span>
                            <span class="badge bg-primary"><%= entry.getValue() %></span>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-warning">
                    <div class="card-header bg-warning text-dark">
                        <h6 class="mb-0">
                            <i class="fas fa-lightbulb me-2"></i>Interpretación del Reporte
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <h6>Nivel de Precisión Diagnóstica:</h6>
                            <% if (porcentajeExactitud >= 70) { %>
                            <div class="alert alert-success" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <strong>Excelente:</strong> La enfermedad se diagnostica con alta precisión (≥70% exactos)
                            </div>
                            <% } else if (porcentajeExactitud >= 50) { %>
                            <div class="alert alert-warning" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Bueno:</strong> Diagnóstico moderadamente preciso (50-69% exactos)
                            </div>
                            <% } else { %>
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-times-circle me-2"></i>
                                <strong>Requiere Atención:</strong> Baja precisión diagnóstica (<50% exactos)
                            </div>
                            <% } %>
                        </div>
                        
                        <h6>Recomendaciones:</h6>
                        <ul class="list-unstyled">
                            <% if (porcentajeExactitud < 70) { %>
                            <li><i class="fas fa-arrow-right text-warning me-2"></i>Revisar síntomas definidos para la enfermedad</li>
                            <li><i class="fas fa-arrow-right text-warning me-2"></i>Considerar síntomas adicionales o específicos</li>
                            <% } %>
                            <li><i class="fas fa-arrow-right text-info me-2"></i>Realizar seguimiento de casos aproximados</li>
                            <li><i class="fas fa-arrow-right text-info me-2"></i>Documentar patrones de síntomas comunes</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

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
                            <a href="reportes?action=estadisticasEnfermedades" class="btn btn-outline-warning">
                                <i class="fas fa-chart-pie me-2"></i>Ver Todas las Estadísticas
                            </a>
                            <a href="reportes?action=enfermedad" class="btn btn-outline-info">
                                <i class="fas fa-virus me-2"></i>Otra Enfermedad
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
