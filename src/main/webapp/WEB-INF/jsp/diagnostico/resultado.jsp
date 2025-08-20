<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultado del Diagnóstico - Sistema Diagnóstico Médico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .resultado-exacto {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .resultado-aproximado {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .progreso-confianza {
            height: 10px;
            border-radius: 5px;
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
        <%
        Diagnostico diagnostico = (Diagnostico) request.getAttribute("diagnostico");
        Paciente paciente = (Paciente) request.getAttribute("paciente");
        List<Sintoma> sintomas = (List<Sintoma>) request.getAttribute("sintomas");
        List<Integer> sintomasSeleccionados = (List<Integer>) request.getAttribute("sintomasSeleccionados");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        %>

        <div class="row">
            <div class="col-12">
                <div class="text-center mb-4">
                    <h2><i class="fas fa-diagnoses me-2"></i>Resultado del Diagnóstico</h2>
                    <p class="text-muted">Diagnóstico realizado el <%= sdf.format(diagnostico.getFecha()) %></p>
                </div>

                <!-- Información del paciente -->
                <div class="card mb-4">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0"><i class="fas fa-user me-2"></i>Información del Paciente</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <strong>DUI:</strong> <%= paciente.getId() %>
                            </div>
                            <div class="col-md-4">
                                <strong>Nombre:</strong> <%= paciente.getNombre() %>
                            </div>
                            <div class="col-md-4">
                                <strong>Edad:</strong> <%= paciente.getEdad() %> años
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Síntomas presentados -->
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-clipboard-list me-2"></i>Síntomas Presentados</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <% 
                            for (Integer sintomaId : sintomasSeleccionados) {
                                for (Sintoma sintoma : sintomas) {
                                    if (sintoma.getId() == sintomaId) {
                            %>
                            <div class="col-md-6 mb-2">
                                <span class="badge bg-primary me-2"><%= sintoma.getId() %></span>
                                <%= sintoma.getNombre() %>
                            </div>
                            <%
                                        break;
                                    }
                                }
                            }
                            %>
                        </div>
                    </div>
                </div>

                <!-- Resultado del diagnóstico -->
                <% if (diagnostico.isEsExacto()) { %>
                <!-- Diagnóstico Exacto -->
                <div class="card mb-4 border-success">
                    <div class="card-header resultado-exacto">
                        <h4 class="mb-0">
                            <i class="fas fa-check-circle me-2"></i>Diagnóstico Exacto
                        </h4>
                    </div>
                    <div class="card-body">
                        <div class="text-center py-4">
                            <i class="fas fa-medal fa-4x text-success mb-3"></i>
                            <h3 class="text-success mb-3"><%= diagnostico.getEnfermedadDiagnosticada() %></h3>
                            <div class="progress progreso-confianza mb-3" style="height: 20px;">
                                <div class="progress-bar bg-success" role="progressbar" style="width: 100%">
                                    100% de Confianza
                                </div>
                            </div>
                            <p class="text-muted">
                                Los síntomas presentados coinciden exactamente con una enfermedad registrada en el sistema.
                            </p>
                        </div>
                    </div>
                </div>
                <% } else { %>
                <!-- Diagnóstico Aproximado -->
                <div class="card mb-4 border-warning">
                    <div class="card-header resultado-aproximado">
                        <h4 class="mb-0">
                            <i class="fas fa-exclamation-triangle me-2"></i>No se puede emitir un diagnostico fiable con la información proporcionada
                        </h4>
                    </div>
                    <div class="card-body">
                        <% if (diagnostico.getResultadosAproximados() != null && !diagnostico.getResultadosAproximados().isEmpty()) { %>
                        <p class="mb-4">
                            No se encontró una coincidencia exacta. A continuación se muestran las enfermedades 
                            más probables basadas en los síntomas presentados:
                        </p>
                        
                        <% for (int i = 0; i < diagnostico.getResultadosAproximados().size(); i++) { 
                           ResultadoDiagnostico resultado = diagnostico.getResultadosAproximados().get(i);
                           String badgeClass = i == 0 ? "warning" : (i == 1 ? "info" : "secondary");
                           String iconClass = i == 0 ? "trophy" : (i == 1 ? "medal" : "award");
                        %>
                        <div class="card mb-3 border-<%= badgeClass %>">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-1 text-center">
                                        <i class="fas fa-<%= iconClass %> fa-2x text-<%= badgeClass %>"></i>
                                        <div class="mt-2">
                                            <span class="badge bg-<%= badgeClass %>">#<%= i + 1 %></span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <h5 class="mb-1"><%= resultado.getNombreEnfermedad() %></h5>
                                        <p class="mb-0 text-muted">
                                            <%= resultado.getSintomasCoincidentes() %> de <%= resultado.getTotalSintomas() %> síntomas coinciden
                                        </p>
                                    </div>
                                    <div class="col-md-5">
                                        <div class="progress progreso-confianza mb-2">
                                            <div class="progress-bar bg-<%= badgeClass %>" role="progressbar" 
                                                 style="width: <%= resultado.getPorcentajeConfianza() %>%">
                                                <%= String.format("%.1f", resultado.getPorcentajeConfianza()) %>%
                                            </div>
                                        </div>
                                        <small class="text-muted">Nivel de confianza</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        <% } else { %>
                        <div class="text-center py-4">
                            <i class="fas fa-question-circle fa-4x text-muted mb-3"></i>
                            <h5 class="text-muted">No se puede emitir un diagnóstico fiable</h5>
                            <p class="text-muted">
                                Los síntomas presentados no coinciden suficientemente con ninguna enfermedad registrada.
                            </p>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>

                <!-- Acciones -->
                <div class="card">
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-3 mb-2">
                                <a href="diagnostico" class="btn btn-primary w-100">
                                    <i class="fas fa-plus me-2"></i>Nuevo Diagnóstico
                                </a>
                            </div>
                            <div class="col-md-3 mb-2">
                                <a href="diagnostico?action=historial" class="btn btn-outline-primary w-100">
                                    <i class="fas fa-history me-2"></i>Ver Historial
                                </a>
                            </div>
                            <div class="col-md-3 mb-2">
                                <a href="reportes?action=paciente&pacienteId=<%= paciente.getId() %>" class="btn btn-outline-success w-100">
                                    <i class="fas fa-file-pdf me-2"></i>Reporte del Paciente
                                </a>
                            </div>
                            <div class="col-md-3 mb-2">
                                <a href="pacientes?action=view&id=<%= paciente.getId() %>" class="btn btn-outline-info w-100">
                                    <i class="fas fa-user me-2"></i>Ver Paciente
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Información importante -->
                <div class="alert alert-warning mt-4">
                    <h6><i class="fas fa-exclamation-triangle me-2"></i>Importante</h6>
                    <p class="mb-0">
                        Este diagnóstico ha sido generado automáticamente y debe ser interpretado por personal 
                        médico calificado. El resultado se ha guardado en el historial del paciente.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
