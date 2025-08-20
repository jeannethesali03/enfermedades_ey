<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mycompany.diagnosticomedico2.model.*"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Diagnósticos - Sistema Diagnóstico Médico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .diagnostico-exacto {
            border-left: 4px solid #28a745;
            background-color: #f8fff9;
        }
        .diagnostico-aproximado {
            border-left: 4px solid #ffc107;
            background-color: #fffef8;
        }
        .timeline-item {
            position: relative;
            padding-left: 3rem;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: -30px;
            width: 2px;
            background: #dee2e6;
        }
        .timeline-item:last-child::before {
            bottom: 50%;
        }
        .timeline-icon {
            position: absolute;
            left: 0;
            top: 10px;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            z-index: 1;
        }
        .badge-confianza {
            font-size: 0.75em;
        }
    </style>
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
                <!-- Encabezado -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>
                        <i class="fas fa-history me-2 text-primary"></i>
                        Historial de Diagnósticos
                    </h2>
                    <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-primary">
                        <i class="fas fa-plus me-1"></i> Nuevo Diagnóstico
                    </a>
                </div>

                <%
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> historial = (List<Map<String, Object>>) request.getAttribute("historial");
                    @SuppressWarnings("unchecked")
                    List<Sintoma> sintomas = (List<Sintoma>) request.getAttribute("sintomas");
                    
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
                %>

                <!-- Estadísticas rápidas -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card text-center bg-primary text-white">
                            <div class="card-body">
                                <i class="fas fa-notes-medical fa-2x mb-2"></i>
                                <h4><%= historial != null ? historial.size() : 0 %></h4>
                                <p class="mb-0">Total Diagnósticos</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-center bg-success text-white">
                            <div class="card-body">
                                <i class="fas fa-bullseye fa-2x mb-2"></i>
                                <%
                                    long exactos = 0;
                                    if (historial != null) {
                                        exactos = historial.stream()
                                            .mapToLong(h -> ((Diagnostico) h.get("diagnostico")).isEsExacto() ? 1 : 0)
                                            .sum();
                                    }
                                %>
                                <h4><%= exactos %></h4>
                                <p class="mb-0">Exactos</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-center bg-warning text-white">
                            <div class="card-body">
                                <i class="fas fa-search fa-2x mb-2"></i>
                                <h4><%= historial != null ? historial.size() - exactos : 0 %></h4>
                                <p class="mb-0">Aproximados</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-center bg-info text-white">
                            <div class="card-body">
                                <i class="fas fa-users fa-2x mb-2"></i>
                                <%
                                    Set<String> pacientesUnicos = new HashSet<>();
                                    if (historial != null) {
                                        for (Map<String, Object> item : historial) {
                                            Paciente p = (Paciente) item.get("paciente");
                                            pacientesUnicos.add(p.getId());
                                        }
                                    }
                                %>
                                <h4><%= pacientesUnicos.size() %></h4>
                                <p class="mb-0">Pacientes</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Lista de diagnósticos -->
                <div class="card">
                    <div class="card-header bg-light">
                        <h5 class="mb-0">
                            <i class="fas fa-clipboard-list me-2"></i>
                            Registro Completo de Diagnósticos
                        </h5>
                    </div>
                    <div class="card-body">
                        <% if (historial == null || historial.isEmpty()) { %>
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">No hay diagnósticos registrados</h4>
                            <p class="text-muted">Realice su primer diagnóstico para comenzar a crear el historial.</p>
                            <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-primary">
                                <i class="fas fa-plus me-1"></i> Realizar Primer Diagnóstico
                            </a>
                        </div>
                        <% } else { %>
                        
                        <!-- Timeline de diagnósticos -->
                        <div class="timeline">
                            <%
                                for (int i = 0; i < historial.size(); i++) {
                                    Map<String, Object> item = historial.get(i);
                                    Paciente paciente = (Paciente) item.get("paciente");
                                    Diagnostico diagnostico = (Diagnostico) item.get("diagnostico");
                                    
                                    String claseCard = diagnostico.isEsExacto() ? "diagnostico-exacto" : "diagnostico-aproximado";
                                    String iconClass = diagnostico.isEsExacto() ? "fas fa-check-circle text-success" : "fas fa-exclamation-triangle text-warning";
                                    String badgeBg = diagnostico.isEsExacto() ? "bg-success" : "bg-warning";
                            %>
                            <div class="timeline-item mb-4">
                                <div class="timeline-icon <%= badgeBg %>">
                                    <i class="<%= diagnostico.isEsExacto() ? "fas fa-check" : "fas fa-question" %> text-white"></i>
                                </div>
                                
                                <div class="card <%= claseCard %>">
                                    <div class="card-header">
                                        <div class="row align-items-center">
                                            <div class="col-md-8">
                                                <h6 class="mb-1">
                                                    <i class="fas fa-user me-2"></i>
                                                    <strong><%= paciente.getNombre() %></strong> 
                                                    <small class="text-muted">(DUI: <%= paciente.getId() %>, <%= paciente.getEdad() %> años)</small>
                                                </h6>
                                                <small class="text-muted">
                                                    <i class="fas fa-calendar me-1"></i>
                                                    <%= sdf.format(diagnostico.getFecha()) %> a las <%= sdfHora.format(diagnostico.getFecha()) %>
                                                </small>
                                            </div>
                                            <div class="col-md-4 text-end">
                                                <span class="badge <%= badgeBg %> fs-6">
                                                    <i class="<%= iconClass.split(" ")[1] %> me-1"></i>
                                                    <%= diagnostico.isEsExacto() ? "Exacto" : "Parcial" %>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="card-body">
                                        <!-- Síntomas presentados -->
                                        <div class="mb-3">
                                            <h6 class="text-secondary mb-2">
                                                <i class="fas fa-clipboard-list me-1"></i>
                                                Síntomas presentados:
                                            </h6>
                                            <div class="d-flex flex-wrap gap-1">
                                                <%
                                                    if (diagnostico.getSintomasSeleccionados() != null) {
                                                        for (Integer sintomaId : diagnostico.getSintomasSeleccionados()) {
                                                            Sintoma sintoma = sintomas.stream()
                                                                    .filter(s -> s.getId() == sintomaId)
                                                                    .findFirst()
                                                                    .orElse(null);
                                                            if (sintoma != null) {
                                                %>
                                                <span class="badge bg-light text-dark border">
                                                    <%= sintoma.getNombre() %>
                                                </span>
                                                <%
                                                            }
                                                        }
                                                    }
                                                %>
                                            </div>
                                        </div>
                                        
                                        <!-- Resultado del diagnóstico -->
                                        <div class="mb-2">
                                            <h6 class="text-secondary mb-2">
                                                <i class="fas fa-diagnoses me-1"></i>
                                                Resultado:
                                            </h6>
                                            
                                            <% if (diagnostico.isEsExacto()) { %>
                                            <div class="alert alert-success mb-0">
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-medal fa-2x text-success me-3"></i>
                                                    <div>
                                                        <strong class="fs-5"><%= diagnostico.getEnfermedadDiagnosticada() %></strong>
                                                        <br>
                                                        <span class="badge badge-confianza bg-success">100% de confianza</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } else { %>
                                            <div class="alert alert-warning mb-0">
                                                <% if (diagnostico.getResultadosAproximados() != null && !diagnostico.getResultadosAproximados().isEmpty()) { %>
                                                <p class="mb-2"><strong>Posibles diagnósticos:</strong></p>
                                                <%
                                                    for (int j = 0; j < Math.min(3, diagnostico.getResultadosAproximados().size()); j++) {
                                                        ResultadoDiagnostico resultado = diagnostico.getResultadosAproximados().get(j);
                                                        String badgeColor = j == 0 ? "warning" : (j == 1 ? "info" : "secondary");
                                                %>
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <span><%= resultado.getNombreEnfermedad() %></span>
                                                    <span class="badge badge-confianza bg-<%= badgeColor %>">
                                                        <%= String.format("%.1f", resultado.getPorcentajeConfianza()) %>%
                                                    </span>
                                                </div>
                                                <% } %>
                                                <% } else { %>
                                                <p class="mb-0">
                                                    <i class="fas fa-exclamation-circle me-2"></i>
                                                    <%= diagnostico.getEnfermedadDiagnosticada() %>
                                                </p>
                                                <% } %>
                                            </div>
                                            <% } %>
                                        </div>
                                        
                                        <!-- Acciones rápidas -->
                                        <div class="text-end">
                                            <a href="${pageContext.request.contextPath}/pacientes?action=view&id=<%= paciente.getId() %>" 
                                               class="btn btn-sm btn-outline-info">
                                                <i class="fas fa-user me-1"></i> Ver Paciente
                                            </a>
                                            <a href="${pageContext.request.contextPath}/reportes?action=paciente&pacienteId=<%= paciente.getId() %>" 
                                               class="btn btn-sm btn-outline-success">
                                                <i class="fas fa-file-alt me-1"></i> Reporte
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Botones de acción -->
                <div class="row mt-4">
                    <div class="col-12 text-center">
                        <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-primary me-2">
                            <i class="fas fa-plus me-1"></i> Nuevo Diagnóstico
                        </a>
                        <a href="${pageContext.request.contextPath}/reportes" class="btn btn-outline-primary">
                            <i class="fas fa-chart-bar me-1"></i> Ver Reportes
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
