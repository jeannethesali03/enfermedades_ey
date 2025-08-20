<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seleccionar Enfermedad - Sistema Diagnóstico Médico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .disease-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .disease-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .search-box {
            border-radius: 25px;
            padding: 10px 20px;
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
        <!-- Encabezado -->
        <div class="text-center mb-4">
            <h2><i class="fas fa-virus me-2"></i>Seleccionar Enfermedad para Reporte</h2>
            <p class="text-muted">Seleccione la enfermedad de la cual desea generar un reporte detallado</p>
        </div>

        <%
        @SuppressWarnings("unchecked")
        Map<String, Integer> enfermedadesConCasos = (Map<String, Integer>) request.getAttribute("enfermedadesConCasos");
        
        // Convertir a lista y ordenar por número de casos
        List<Map.Entry<String, Integer>> enfermedadesOrdenadas = new ArrayList<>();
        if (enfermedadesConCasos != null) {
            enfermedadesOrdenadas.addAll(enfermedadesConCasos.entrySet());
            enfermedadesOrdenadas.sort((e1, e2) -> e2.getValue().compareTo(e1.getValue()));
        }
        %>

        <% if (enfermedadesOrdenadas != null && !enfermedadesOrdenadas.isEmpty()) { %>
        
        <!-- Barra de búsqueda -->
        <div class="row mb-4">
            <div class="col-md-6 mx-auto">
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-search"></i>
                    </span>
                    <input type="text" class="form-control search-box" id="searchEnfermedad" 
                           placeholder="Buscar enfermedad..." style="border-left: none;">
                </div>
            </div>
        </div>

        <!-- Lista de enfermedades -->
        <div class="row" id="enfermedadesList">
            <% 
            int contador = 1;
            for (Map.Entry<String, Integer> entry : enfermedadesOrdenadas) { 
                String nombreEnfermedad = entry.getKey();
                int totalCasos = entry.getValue();
            %>
            <div class="col-md-6 col-lg-4 mb-3 enfermedad-item" data-nombre="<%= nombreEnfermedad.toLowerCase() %>">
                <div class="card disease-card h-100 border-info">
                    <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
                        <span class="fw-bold">#<%= contador++ %></span>
                        <span class="badge bg-light text-dark fs-6"><%= totalCasos %> casos</span>
                    </div>
                    <div class="card-body">
                        <h6 class="card-title">
                            <i class="fas fa-virus text-danger me-2"></i>
                            <%= nombreEnfermedad %>
                        </h6>
                        <p class="text-muted mb-3">
                            <small>
                                <i class="fas fa-users me-1"></i>
                                <%= totalCasos %> paciente<%= totalCasos != 1 ? "s" : "" %> diagnosticado<%= totalCasos != 1 ? "s" : "" %>
                            </small>
                        </p>
                        
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="btn-group w-100">
                                <a href="reportes?action=enfermedad&enfermedadNombre=<%= java.net.URLEncoder.encode(nombreEnfermedad, "UTF-8") %>" 
                                   class="btn btn-info">
                                    <i class="fas fa-file-alt me-1"></i>Generar Reporte
                                </a>
                                <a href="reportes?action=enfermedad&enfermedadNombre=<%= java.net.URLEncoder.encode(nombreEnfermedad, "UTF-8") %>" 
                                   class="btn btn-outline-info">
                                    <i class="fas fa-eye"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <!-- Mensaje cuando no hay resultados de búsqueda -->
        <div id="noResults" class="text-center py-5" style="display: none;">
            <i class="fas fa-search fa-3x text-muted mb-3"></i>
            <h5 class="text-muted">No se encontraron enfermedades</h5>
            <p class="text-muted">Intente con otros términos de búsqueda</p>
        </div>

        <% } else { %>
        <!-- No hay enfermedades -->
        <div class="text-center py-5">
            <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
            <h4>No hay enfermedades diagnosticadas</h4>
            <p class="text-muted">Debe realizar al menos un diagnóstico para generar reportes por enfermedad</p>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/diagnostico" class="btn btn-primary">
                    <i class="fas fa-diagnoses me-2"></i>Realizar Diagnóstico
                </a>
                <a href="${pageContext.request.contextPath}/reportes" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Volver a Reportes
                </a>
            </div>
        </div>
        <% } %>

        <!-- Acciones adicionales -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card border-secondary">
                    <div class="card-header bg-secondary text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-cogs me-2"></i>Otras Opciones de Reportes
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="reportes?action=estadisticasEnfermedades" class="btn btn-outline-warning">
                                <i class="fas fa-chart-pie me-2"></i>Ver Estadísticas de Enfermedades
                            </a>
                            <a href="reportes?action=global" class="btn btn-outline-primary">
                                <i class="fas fa-globe me-2"></i>Reporte Global
                            </a>
                            <a href="reportes?action=paciente" class="btn btn-outline-success">
                                <i class="fas fa-user-md me-2"></i>Reporte por Paciente
                            </a>
                            <a href="reportes" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Volver a Reportes
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Información adicional -->
        <div class="row mt-3">
            <div class="col-12">
                <div class="card border-info">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-info-circle me-2"></i>¿Qué incluye el reporte por enfermedad?
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Información de la Enfermedad:</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-check text-success me-2"></i>Nombre y descripción</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Síntomas asociados</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Estadísticas generales</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6>Casos Diagnosticados:</h6>
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-check text-success me-2"></i>Lista completa de pacientes</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Tipo de diagnóstico (exacto/aproximado)</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Fechas y síntomas por caso</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Funcionalidad de búsqueda en tiempo real
        document.getElementById('searchEnfermedad').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase().trim();
            const enfermedadItems = document.querySelectorAll('.enfermedad-item');
            const noResults = document.getElementById('noResults');
            let visibleCount = 0;

            enfermedadItems.forEach(function(item) {
                const nombreEnfermedad = item.getAttribute('data-nombre');
                
                if (nombreEnfermedad.includes(searchTerm)) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });

            // Mostrar mensaje de "no hay resultados" si es necesario
            if (visibleCount === 0 && searchTerm !== '') {
                noResults.style.display = 'block';
            } else {
                noResults.style.display = 'none';
            }
        });

        // Limpiar búsqueda con Escape
        document.getElementById('searchEnfermedad').addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                this.value = '';
                this.dispatchEvent(new Event('input'));
                this.blur();
            }
        });
    </script>
</body>
</html>
