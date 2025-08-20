<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Paciente" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Diagnostico" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Pacientes - Sistema Diagnóstico Médico</title>
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

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-users me-2"></i>Gestión de Pacientes</h2>
                    <div>
                        <% 
                        List<Paciente> pacientes = (List<Paciente>) request.getAttribute("pacientes");
                        int totalPacientes = pacientes != null ? pacientes.size() : 0;
                        %>
                        <span class="badge bg-info me-2">
                            <%= totalPacientes %> pacientes registrados
                        </span>
                        <a href="pacientes?action=new" class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>Nuevo Paciente
                        </a>
                    </div>
                </div>

                <!-- Mostrar mensajes -->
                <% 
                String mensaje = (String) request.getAttribute("mensaje");
                String tipoMensaje = (String) request.getAttribute("tipoMensaje");
                if (mensaje != null && !mensaje.isEmpty()) {
                %>
                <div class="alert alert-<%= "error".equals(tipoMensaje) ? "danger" : "success" %> alert-dismissible fade show" role="alert">
                    <%= mensaje %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% } %>

                <!-- Lista de pacientes -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Lista de Pacientes Registrados</h5>
                    </div>
                    <div class="card-body">
                        <% if (pacientes == null || pacientes.isEmpty()) { %>
                        <div class="text-center py-4">
                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No hay pacientes registrados</h5>
                            <p class="text-muted">Comience registrando pacientes para poder realizar diagnósticos.</p>
                            <a href="pacientes?action=new" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Registrar Primer Paciente
                            </a>
                        </div>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>DUI</th>
                                        <th>Nombre Completo</th>
                                        <th>Edad</th>
                                        <th>Diagnósticos</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
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
                                            <% if (paciente.getDiagnosticos().isEmpty()) { %>
                                            <span class="badge bg-secondary">Sin diagnósticos</span>
                                            <% } else { %>
                                            <% 
                                            Diagnostico ultimoDiagnostico = paciente.getDiagnosticos().get(paciente.getDiagnosticos().size() - 1);
                                            %>
                                            <% if (ultimoDiagnostico.isEsExacto()) { %>
                                            <span class="badge bg-success">Diagnóstico exacto</span>
                                            <% } else { %>
                                            <span class="badge bg-warning">Diagnóstico no concluyente</span>
                                            <% } %>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a href="pacientes?action=view&id=<%= paciente.getId() %>" 
                                                   class="btn btn-outline-info" title="Ver detalles">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="pacientes?action=edit&id=<%= paciente.getId() %>" 
                                                   class="btn btn-outline-primary" title="Editar">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <form method="post" action="pacientes" class="d-inline" 
                                                      onsubmit="return confirm('¿Está seguro de eliminar este paciente y todos sus diagnósticos?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="<%= paciente.getId() %>">
                                                    <button type="submit" class="btn btn-outline-danger" title="Eliminar">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Estadísticas y acciones rápidas -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card border-info">
                            <div class="card-header bg-info text-white">
                                <h6 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Estadísticas</h6>
                            </div>
                            <div class="card-body">
                                <% 
                                int pacientesConDiagnosticos = 0;
                                int totalDiagnosticos = 0;
                                if (pacientes != null) {
                                    for (Paciente p : pacientes) {
                                        if (!p.getDiagnosticos().isEmpty()) {
                                            pacientesConDiagnosticos++;
                                        }
                                        totalDiagnosticos += p.getDiagnosticos().size();
                                    }
                                }
                                %>
                                <p class="mb-1">Total de pacientes: <strong><%= totalPacientes %></strong></p>
                                <p class="mb-1">Con diagnósticos: <strong><%= pacientesConDiagnosticos %></strong></p>
                                <p class="mb-0">Total diagnósticos: <strong><%= totalDiagnosticos %></strong></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card border-success">
                            <div class="card-header bg-success text-white">
                                <h6 class="mb-0"><i class="fas fa-tasks me-2"></i>Acciones Rápidas</h6>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-primary btn-sm">
                                        <i class="fas fa-diagnoses me-2"></i>Realizar Diagnóstico
                                    </a>
                                    <% if (totalDiagnosticos > 0) { %>
                                    <a href="${pageContext.request.contextPath}/diagnostico?action=historial" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-history me-2"></i>Ver Historial
                                    </a>
                                    <a href="${pageContext.request.contextPath}/reportes" class="btn btn-outline-success btn-sm">
                                        <i class="fas fa-file-pdf me-2"></i>Generar Reportes
                                    </a>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Información importante -->
                <div class="alert alert-warning mt-4">
                    <h6><i class="fas fa-info-circle me-2"></i>Criterios de Validación para Pacientes:</h6>
                    <ul class="mb-0">
                        <li><strong>El DUI debe ser único y tener formato: 12345678-9</strong></li>
                        <li>El nombre debe tener al menos 3 caracteres</li>
                        <li><strong>El nombre solo puede contener letras, espacios y acentos</strong></li>
                        <li>La edad debe estar entre 0 y 120 años</li>
                        <li>Todos los campos son obligatorios</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
