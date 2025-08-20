<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Enfermedad" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Sintoma" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Enfermedades - Sistema Diagnóstico Médico</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/enfermedades">Enfermedades</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/pacientes">Pacientes</a>
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
                    <h2><i class="fas fa-virus me-2"></i>Gestión de Enfermedades</h2>
                    <div>
                        <% 
                        List<Enfermedad> enfermedades = (List<Enfermedad>) request.getAttribute("enfermedades");
                        List<Sintoma> sintomas = (List<Sintoma>) request.getAttribute("sintomas");
                        Integer maxEnfermedades = (Integer) request.getAttribute("maxEnfermedades");
                        int totalEnfermedades = enfermedades != null ? enfermedades.size() : 0;
                        int totalSintomas = sintomas != null ? sintomas.size() : 0;
                        %>
                        <span class="badge bg-info me-2">
                            <%= totalEnfermedades %> / <%= maxEnfermedades %> enfermedades
                        </span>
                        <% if (totalSintomas > 0 && totalEnfermedades < maxEnfermedades) { %>
                        <a href="enfermedades?action=new" class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>Nueva Enfermedad
                        </a>
                        <% } %>
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

                <!-- Verificar si hay síntomas -->
                <% if (totalSintomas == 0) { %>
                <div class="alert alert-warning">
                    <h5><i class="fas fa-exclamation-triangle me-2"></i>Síntomas Requeridos</h5>
                    <p>Debe registrar síntomas antes de poder crear enfermedades.</p>
                    <a href="${pageContext.request.contextPath}/sintomas" class="btn btn-warning">
                        <i class="fas fa-clipboard-list me-2"></i>Ir a Síntomas
                    </a>
                </div>
                <% } %>

                <!-- Lista de enfermedades -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Lista de Enfermedades Registradas</h5>
                    </div>
                    <div class="card-body">
                        <% if (enfermedades == null || enfermedades.isEmpty()) { %>
                        <div class="text-center py-4">
                            <i class="fas fa-virus fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No hay enfermedades registradas</h5>
                            <p class="text-muted">Las enfermedades deben asociarse con síntomas para realizar diagnósticos.</p>
                            <% if (totalSintomas > 0) { %>
                            <a href="enfermedades?action=new" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Agregar Primera Enfermedad
                            </a>
                            <% } %>
                        </div>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nombre de la Enfermedad</th>
                                        <th>Síntomas Asociados</th>
                                        <th>Total Síntomas</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Enfermedad enfermedad : enfermedades) { %>
                                    <tr>
                                        <td><%= enfermedad.getId() %></td>
                                        <td><strong><%= enfermedad.getNombre() %></strong></td>
                                        <td>
                                            <% 
                                            StringBuilder sintomasTexto = new StringBuilder();
                                            for (Integer sintomaId : enfermedad.getSintomasIds()) {
                                                for (Sintoma sintoma : sintomas) {
                                                    if (sintoma.getId() == sintomaId) {
                                                        if (sintomasTexto.length() > 0) sintomasTexto.append(", ");
                                                        sintomasTexto.append(sintoma.getNombre());
                                                        break;
                                                    }
                                                }
                                            }
                                            %>
                                            <small class="text-muted"><%= sintomasTexto.toString() %></small>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary"><%= enfermedad.getSintomasIds().size() %></span>
                                        </td>
                                        <td>
                                            <form method="post" action="enfermedades" class="d-inline" 
                                                  onsubmit="return confirm('¿Está seguro de eliminar esta enfermedad?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= enfermedad.getId() %>">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="fas fa-trash me-1"></i>Eliminar
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>
                </div>

                <!-- Información adicional -->
                <div class="row mt-4">
                    <div class="col-md-4">
                        <div class="card border-info">
                            <div class="card-header bg-info text-white">
                                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Información</h6>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled mb-0">
                                    <li><i class="fas fa-check text-success me-2"></i>Máximo 10 enfermedades</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Mínimo 3 caracteres por nombre</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Al menos 1 síntoma asociado</li>
                                    <li><i class="fas fa-check text-success me-2"></i>No se permiten duplicados</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-success">
                            <div class="card-header bg-success text-white">
                                <h6 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Estadísticas</h6>
                            </div>
                            <div class="card-body">
                                <p class="mb-1">Síntomas disponibles: <strong><%= totalSintomas %></strong></p>
                                <p class="mb-1">Enfermedades registradas: <strong><%= totalEnfermedades %></strong></p>
                                <p class="mb-0">Capacidad disponible: <strong><%= maxEnfermedades - totalEnfermedades %></strong></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-warning">
                            <div class="card-header bg-warning text-dark">
                                <h6 class="mb-0"><i class="fas fa-arrow-right me-2"></i>Siguiente Paso</h6>
                            </div>
                            <div class="card-body">
                                <p class="mb-2">Una vez que haya registrado enfermedades:</p>
                                <a href="${pageContext.request.contextPath}/pacientes" class="btn btn-warning btn-sm me-2">
                                    <i class="fas fa-users me-2"></i>Registrar Pacientes
                                </a>
                                <% if (totalEnfermedades > 0) { %>
                                <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-primary btn-sm">
                                    <i class="fas fa-diagnoses me-2"></i>Diagnosticar
                                </a>
                                <% } %>
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
