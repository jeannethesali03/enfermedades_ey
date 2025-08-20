<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Paciente" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seleccionar Paciente - Reportes</title>
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
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-user-check me-2"></i>Seleccionar Paciente para Reporte
                        </h4>
                    </div>
                    <div class="card-body">
                        <%
                        List<Paciente> pacientes = (List<Paciente>) request.getAttribute("pacientes");
                        %>
                        
                        <% if (pacientes == null || pacientes.isEmpty()) { %>
                        <div class="text-center py-4">
                            <i class="fas fa-user-times fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No hay pacientes con diagnósticos</h5>
                            <p class="text-muted">Para generar reportes por paciente, primero debe realizar diagnósticos.</p>
                            <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-primary">
                                <i class="fas fa-diagnoses me-2"></i>Realizar Diagnósticos
                            </a>
                        </div>
                        <% } else { %>
                        <p class="mb-4">Seleccione el paciente para el cual desea generar el reporte detallado:</p>
                        
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>DUI Paciente</th>
                                        <th>Nombre</th>
                                        <th>Edad</th>
                                        <th>Diagnósticos</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Paciente paciente : pacientes) { %>
                                    <tr>
                                        <td><strong><%= paciente.getId() %></strong></td>
                                        <td><%= paciente.getNombre() %></td>
                                        <td><%= paciente.getEdad() %> años</td>
                                        <td>
                                            <span class="badge bg-primary"><%= paciente.getDiagnosticos().size() %></span>
                                        </td>
                                        <td>
                                            <a href="reportes?action=paciente&pacienteId=<%= paciente.getId() %>" 
                                               class="btn btn-success btn-sm">
                                                <i class="fas fa-file-pdf me-2"></i>Generar PDF
                                            </a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                        
                        <div class="mt-4">
                            <a href="reportes" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Volver a Reportes
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="card mt-4 border-info">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>¿Qué incluye el reporte por paciente?</h6>
                    </div>
                    <div class="card-body">
                        <ul class="list-unstyled mb-0">
                            <li><i class="fas fa-user text-primary me-2"></i>Información personal del paciente</li>
                            <li><i class="fas fa-history text-success me-2"></i>Historial completo de diagnósticos</li>
                            <li><i class="fas fa-calendar text-warning me-2"></i>Fechas de cada consulta</li>
                            <li><i class="fas fa-clipboard-list text-info me-2"></i>Síntomas presentados en cada diagnóstico</li>
                            <li><i class="fas fa-percentage text-danger me-2"></i>Porcentajes de confianza (diagnósticos aproximados)</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
