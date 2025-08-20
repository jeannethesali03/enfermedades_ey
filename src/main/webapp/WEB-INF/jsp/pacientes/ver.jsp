<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mycompany.diagnosticomedico2.model.*"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalles del Paciente - Sistema Diagnóstico Médico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .patient-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0;
        }
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
            margin-bottom: 2rem;
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
            top: 15px;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            z-index: 1;
            color: white;
        }
        .stats-card {
            transition: all 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .confidence-bar {
            height: 8px;
            border-radius: 4px;
        }
        .no-diagnosticos {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 2px dashed #dee2e6;
            border-radius: 10px;
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

    <%
        Paciente paciente = (Paciente) request.getAttribute("paciente");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
    %>

    <div class="container mt-4">
        <!-- Encabezado del paciente -->
        <div class="card mb-4 border-0 shadow">
            <div class="patient-header p-4">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="d-flex align-items-center">
                            <div class="me-4">
                                <i class="fas fa-user-circle fa-4x"></i>
                            </div>
                            <div>
                                <h2 class="mb-1"><%= paciente.getNombre() %></h2>
                                <p class="mb-0 opacity-75">
                                    <i class="fas fa-id-card me-2"></i>DUI: <%= paciente.getId() %>
                                    <span class="mx-3">|</span>
                                    <i class="fas fa-birthday-cake me-2"></i><%= paciente.getEdad() %> años
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="btn-group" role="group">
                            <a href="${pageContext.request.contextPath}/pacientes?action=edit&id=<%= paciente.getId() %>" 
                               class="btn btn-light">
                                <i class="fas fa-edit me-1"></i> Editar
                            </a>
                            <a href="${pageContext.request.contextPath}/reportes?action=paciente&pacienteId=<%= paciente.getId() %>" 
                               class="btn btn-success">
                                <i class="fas fa-file-alt me-1"></i> Reporte
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Estadísticas del paciente -->
            <div class="card-body bg-light">
                <div class="row">
                    <div class="col-md-3">
                        <div class="stats-card card text-center bg-primary text-white h-100">
                            <div class="card-body">
                                <i class="fas fa-notes-medical fa-2x mb-2"></i>
                                <h4><%= paciente.getDiagnosticos().size() %></h4>
                                <p class="mb-0">Total Diagnósticos</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card card text-center bg-success text-white h-100">
                            <div class="card-body">
                                <i class="fas fa-bullseye fa-2x mb-2"></i>
                                <%
                                    long exactos = paciente.getDiagnosticos().stream()
                                            .mapToLong(d -> d.isEsExacto() ? 1 : 0)
                                            .sum();
                                %>
                                <h4><%= exactos %></h4>
                                <p class="mb-0">Exactos</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card card text-center bg-warning text-white h-100">
                            <div class="card-body">
                                <i class="fas fa-search fa-2x mb-2"></i>
                                <h4><%= paciente.getDiagnosticos().size() - exactos %></h4>
                                <p class="mb-0">Aproximados</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stats-card card text-center bg-info text-white h-100">
                            <div class="card-body">
                                <i class="fas fa-calendar fa-2x mb-2"></i>
                                <%
                                    String ultimaVisita = "N/A";
                                    if (!paciente.getDiagnosticos().isEmpty()) {
                                        Diagnostico ultimo = paciente.getDiagnosticos().get(paciente.getDiagnosticos().size() - 1);
                                        ultimaVisita = sdf.format(ultimo.getFecha());
                                    }
                                %>
                                <h6><%= ultimaVisita %></h6>
                                <p class="mb-0">Última Visita</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Botones de navegación -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/pacientes" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-1"></i> Volver a Lista
            </a>
            <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-primary">
                <i class="fas fa-plus me-1"></i> Nuevo Diagnóstico
            </a>
        </div>

        <!-- Historial de diagnósticos -->
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">
                    <i class="fas fa-history me-2"></i>
                    Historial de Diagnósticos
                </h4>
            </div>
            <div class="card-body">
                <% if (paciente.getDiagnosticos().isEmpty()) { %>
                <div class="no-diagnosticos text-center py-5">
                    <i class="fas fa-clipboard-list fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">Sin diagnósticos registrados</h4>
                    <p class="text-muted mb-4">
                        Este paciente aún no tiene diagnósticos en su historial médico.
                        <br>Realice el primer diagnóstico para comenzar el seguimiento.
                    </p>
                    <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i> Realizar Primer Diagnóstico
                    </a>
                </div>
                <% } else { %>
                
                <!-- Timeline de diagnósticos -->
                <div class="timeline">
                    <%
                        // Ordenar diagnósticos por fecha (más recientes primero)
                        List<Diagnostico> diagnosticosOrdenados = new ArrayList<>(paciente.getDiagnosticos());
                        diagnosticosOrdenados.sort((d1, d2) -> d2.getFecha().compareTo(d1.getFecha()));
                        
                        for (int i = 0; i < diagnosticosOrdenados.size(); i++) {
                            Diagnostico diagnostico = diagnosticosOrdenados.get(i);
                            String claseCard = diagnostico.isEsExacto() ? "diagnostico-exacto" : "diagnostico-aproximado";
                            String iconBg = diagnostico.isEsExacto() ? "bg-success" : "bg-warning";
                            String iconClass = diagnostico.isEsExacto() ? "fas fa-check" : "fas fa-question";
                    %>
                    <div class="timeline-item">
                        <div class="timeline-icon <%= iconBg %>">
                            <i class="<%= iconClass %>"></i>
                        </div>
                        
                        <div class="card <%= claseCard %> shadow-sm">
                            <div class="card-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h6 class="mb-1">
                                            <i class="fas fa-calendar-alt me-2"></i>
                                            <strong><%= sdf.format(diagnostico.getFecha()) %></strong>
                                            a las <%= sdfHora.format(diagnostico.getFecha()) %>
                                        </h6>
                                        <small class="text-muted">
                                            Diagnóstico #<%= diagnosticosOrdenados.size() - i %>
                                        </small>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <span class="badge <%= diagnostico.isEsExacto() ? "bg-success" : "bg-warning" %> fs-6">
                                            <i class="<%= diagnostico.isEsExacto() ? "fas fa-bullseye" : "fas fa-search" %> me-1"></i>
                                            <%= diagnostico.isEsExacto() ? "Exacto" : "Parcial" %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-body">
                                <!-- Síntomas presentados -->
                                <div class="mb-3">
                                    <h6 class="text-secondary mb-2">
                                        <i class="fas fa-stethoscope me-1"></i>
                                        Síntomas presentados:
                                    </h6>
                                    <div class="d-flex flex-wrap gap-1">
                                        <%
                                            if (diagnostico.getSintomasSeleccionados() != null) {
                                                // Para mostrar los síntomas, necesitamos acceder a la sesión
                                                HttpSession sesion = request.getSession();
                                                @SuppressWarnings("unchecked")
                                                List<Sintoma> sintomas = (List<Sintoma>) sesion.getAttribute("sintomas");
                                                
                                                if (sintomas != null) {
                                                    for (Integer sintomaId : diagnostico.getSintomasSeleccionados()) {
                                                        Sintoma sintoma = sintomas.stream()
                                                                .filter(s -> s.getId() == sintomaId)
                                                                .findFirst()
                                                                .orElse(null);
                                                        if (sintoma != null) {
                                        %>
                                        <span class="badge bg-light text-dark border">
                                            <i class="fas fa-circle me-1" style="font-size: 0.5em;"></i>
                                            <%= sintoma.getNombre() %>
                                        </span>
                                        <%
                                                        }
                                                    }
                                                }
                                            }
                                        %>
                                    </div>
                                </div>
                                
                                <!-- Resultado del diagnóstico -->
                                <div>
                                    <h6 class="text-secondary mb-2">
                                        <i class="fas fa-diagnoses me-1"></i>
                                        Resultado:
                                    </h6>
                                    
                                    <% if (diagnostico.isEsExacto()) { %>
                                    <div class="alert alert-success mb-0">
                                        <div class="row align-items-center">
                                            <div class="col-md-2 text-center">
                                                <i class="fas fa-medal fa-2x text-success"></i>
                                            </div>
                                            <div class="col-md-10">
                                                <h5 class="alert-heading mb-1">
                                                    <%= diagnostico.getEnfermedadDiagnosticada() %>
                                                </h5>
                                                <div class="progress confidence-bar mb-2">
                                                    <div class="progress-bar bg-success" style="width: 100%">
                                                        100% de confianza
                                                    </div>
                                                </div>
                                                <small class="text-muted">
                                                    <i class="fas fa-check-circle me-1"></i>
                                                    Coincidencia exacta con los síntomas registrados
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <% } else { %>
                                    <div class="alert alert-warning mb-0">
                                        <% if (diagnostico.getResultadosAproximados() != null && !diagnostico.getResultadosAproximados().isEmpty()) { %>
                                        <h6 class="alert-heading mb-3">Posibles diagnósticos:</h6>
                                        <%
                                            for (int j = 0; j < Math.min(3, diagnostico.getResultadosAproximados().size()); j++) {
                                                ResultadoDiagnostico resultado = diagnostico.getResultadosAproximados().get(j);
                                                String badgeColor = j == 0 ? "warning" : (j == 1 ? "info" : "secondary");
                                                String iconDiag = j == 0 ? "trophy" : (j == 1 ? "medal" : "award");
                                        %>
                                        <div class="row align-items-center mb-2">
                                            <div class="col-md-1 text-center">
                                                <i class="fas fa-<%= iconDiag %> text-<%= badgeColor %>"></i>
                                            </div>
                                            <div class="col-md-6">
                                                <strong><%= resultado.getNombreEnfermedad() %></strong>
                                                <br>
                                                <small class="text-muted">
                                                    <%= resultado.getSintomasCoincidentes() %> de <%= resultado.getTotalSintomas() %> síntomas
                                                </small>
                                            </div>
                                            <div class="col-md-5">
                                                <div class="progress confidence-bar mb-1">
                                                    <div class="progress-bar bg-<%= badgeColor %>" 
                                                         style="width: <%= resultado.getPorcentajeConfianza() %>%">
                                                    </div>
                                                </div>
                                                <small class="text-<%= badgeColor %>">
                                                    <strong><%= String.format("%.1f", resultado.getPorcentajeConfianza()) %>%</strong>
                                                </small>
                                            </div>
                                        </div>
                                        <% } %>
                                        <% } else { %>
                                        <div class="text-center">
                                            <i class="fas fa-question-circle fa-2x text-muted mb-2"></i>
                                            <p class="mb-0"><%= diagnostico.getEnfermedadDiagnosticada() %></p>
                                        </div>
                                        <% } %>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Panel de acciones -->
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card border-primary">
                    <div class="card-header bg-primary text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-tasks me-2"></i>
                            Acciones del Paciente
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-success">
                                <i class="fas fa-plus me-2"></i> Realizar Nuevo Diagnóstico
                            </a>
                            <a href="${pageContext.request.contextPath}/pacientes?action=edit&id=<%= paciente.getId() %>" 
                               class="btn btn-outline-primary">
                                <i class="fas fa-edit me-2"></i> Editar Información
                            </a>
                            <a href="${pageContext.request.contextPath}/reportes?action=paciente&pacienteId=<%= paciente.getId() %>" 
                               class="btn btn-outline-success">
                                <i class="fas fa-file-pdf me-2"></i> Generar Reporte Médico
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card border-info">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-info-circle me-2"></i>
                            Resumen Médico
                        </h6>
                    </div>
                    <div class="card-body">
                        <% if (!paciente.getDiagnosticos().isEmpty()) { %>
                        <%
                            Diagnostico ultimoDiagnostico = paciente.getDiagnosticos().get(paciente.getDiagnosticos().size() - 1);
                        %>
                        <p class="mb-2">
                            <strong>Último diagnóstico:</strong><br>
                            <%= sdf.format(ultimoDiagnostico.getFecha()) %>
                        </p>
                        <p class="mb-2">
                            <strong>Estado:</strong>
                            <span class="badge <%= ultimoDiagnostico.isEsExacto() ? "bg-success" : "bg-warning" %>">
                                <%= ultimoDiagnostico.isEsExacto() ? "Diagnóstico confirmado" : "Requiere seguimiento" %>
                            </span>
                        </p>
                        <p class="mb-0">
                            <strong>Total consultas:</strong> <%= paciente.getDiagnosticos().size() %>
                        </p>
                        <% } else { %>
                        <p class="text-muted mb-0">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Sin historial médico disponible
                        </p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
