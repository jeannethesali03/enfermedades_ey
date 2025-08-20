<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.diagnosticomedico2.model.Sintoma" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Síntomas - Sistema Diagnóstico Médico</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/sintomas">Síntomas</a>
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
                    <h2><i class="fas fa-clipboard-list me-2"></i>Gestión de Síntomas</h2>
                    <div>
                        <% 
                        List<Sintoma> sintomas = (List<Sintoma>) request.getAttribute("sintomas");
                        Integer maxSintomas = (Integer) request.getAttribute("maxSintomas");
                        int totalSintomas = sintomas != null ? sintomas.size() : 0;
                        %>
                        <span class="badge bg-info me-2">
                            <%= totalSintomas %> / <%= maxSintomas %> síntomas
                        </span>
                        <% if (totalSintomas < maxSintomas) { %>
                        <a href="sintomas?action=new" class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>Nuevo Síntoma
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

                <!-- Barra de búsqueda -->
                <% if (sintomas != null && !sintomas.isEmpty()) { %>
                <div class="card mb-3">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-search text-muted"></i>
                                    </span>
                                    <input type="text" 
                                           id="buscarSintoma" 
                                           class="form-control" 
                                           placeholder="Buscar síntoma por nombre o número..."
                                           autocomplete="off">
                                    <button class="btn btn-outline-secondary" type="button" id="limpiarBusqueda">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-4 mt-2 mt-md-0">
                                <small class="text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    <span id="resultadosBusqueda">Mostrando <%= totalSintomas %> síntomas</span>
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

                <!-- Lista de síntomas -->
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Lista de Síntomas Registrados</h5>
                            <% if (sintomas != null && !sintomas.isEmpty()) { %>
                            <div id="sinResultados" class="d-none">
                                <span class="badge bg-warning">
                                    <i class="fas fa-exclamation-triangle me-1"></i>
                                    Sin resultados
                                </span>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <div class="card-body">
                        <% if (sintomas == null || sintomas.isEmpty()) { %>
                        <div class="text-center py-4">
                            <i class="fas fa-clipboard-list fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No hay síntomas registrados</h5>
                            <p class="text-muted">Comience agregando síntomas para poder registrar enfermedades.</p>
                            <a href="sintomas?action=new" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Agregar Primer Síntoma
                            </a>
                        </div>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-hover" id="tablaSintomas">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Nombre del Síntoma</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="cuerpoTablaSintomas">
                                    <% for (Sintoma sintoma : sintomas) { %>
                                    <tr class="fila-sintoma" 
                                        data-id="<%= sintoma.getId() %>" 
                                        data-nombre="<%= sintoma.getNombre().toLowerCase() %>">
                                        <td><%= sintoma.getId() %></td>
                                        <td><%= sintoma.getNombre() %></td>
                                        <td>
                                            <form method="post" action="sintomas" class="d-inline" 
                                                  onsubmit="return confirm('¿Está seguro de eliminar este síntoma?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= sintoma.getId() %>">
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
                    <div class="col-md-6">
                        <div class="card border-info">
                            <div class="card-header bg-info text-white">
                                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Información</h6>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled mb-0">
                                    <li><i class="fas fa-check text-success me-2"></i>Máximo 10 síntomas</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Mínimo 3 caracteres por nombre</li>
                                    <li><i class="fas fa-check text-success me-2"></i>No se permiten duplicados</li>
                                    <li><i class="fas fa-check text-success me-2"></i>Los síntomas son requeridos para enfermedades</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card border-warning">
                            <div class="card-header bg-warning text-dark">
                                <h6 class="mb-0"><i class="fas fa-exclamation-triangle me-2"></i>Siguiente Paso</h6>
                            </div>
                            <div class="card-body">
                                <p class="mb-2">Una vez que haya registrado síntomas, podrá:</p>
                                <a href="${pageContext.request.contextPath}/enfermedades" class="btn btn-warning btn-sm">
                                    <i class="fas fa-virus me-2"></i>Registrar Enfermedades
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const inputBusqueda = document.getElementById('buscarSintoma');
            const btnLimpiar = document.getElementById('limpiarBusqueda');
            const resultadosBusqueda = document.getElementById('resultadosBusqueda');
            const sinResultados = document.getElementById('sinResultados');
            const filasSintomas = document.querySelectorAll('.fila-sintoma');
            const totalSintomas = <%= totalSintomas %>;
            
            // Función para realizar la búsqueda
            function buscarSintomas() {
                const termino = inputBusqueda.value.toLowerCase().trim();
                let sintomasVisibles = 0;
                
                filasSintomas.forEach(fila => {
                    const id = fila.getAttribute('data-id');
                    const nombre = fila.getAttribute('data-nombre');
                    
                    // Buscar por ID o por nombre
                    const coincideId = id.includes(termino);
                    const coincideNombre = nombre.includes(termino);
                    
                    if (termino === '' || coincideId || coincideNombre) {
                        fila.style.display = '';
                        sintomasVisibles++;
                        
                        // Resaltar coincidencias en el nombre
                        if (termino !== '' && coincideNombre) {
                            const celdaNombre = fila.children[1];
                            const textoOriginal = celdaNombre.textContent;
                            const regex = new RegExp(`(${termino})`, 'gi');
                            celdaNombre.innerHTML = textoOriginal.replace(regex, '<mark class="bg-warning">$1</mark>');
                        } else {
                            // Restaurar texto original
                            const celdaNombre = fila.children[1];
                            celdaNombre.innerHTML = celdaNombre.textContent;
                        }
                        
                        // Resaltar coincidencias en el ID
                        if (termino !== '' && coincideId) {
                            const celdaId = fila.children[0];
                            const textoOriginal = celdaId.textContent;
                            const regex = new RegExp(`(${termino})`, 'gi');
                            celdaId.innerHTML = textoOriginal.replace(regex, '<mark class="bg-warning">$1</mark>');
                        } else {
                            // Restaurar texto original
                            const celdaId = fila.children[0];
                            celdaId.innerHTML = celdaId.textContent;
                        }
                    } else {
                        fila.style.display = 'none';
                    }
                });
                
                // Actualizar contador de resultados
                if (termino === '') {
                    resultadosBusqueda.textContent = `Mostrando ${totalSintomas} síntomas`;
                    sinResultados.classList.add('d-none');
                } else if (sintomasVisibles === 0) {
                    resultadosBusqueda.textContent = 'Sin resultados encontrados';
                    sinResultados.classList.remove('d-none');
                } else {
                    resultadosBusqueda.textContent = `Encontrados ${sintomasVisibles} de ${totalSintomas} síntomas`;
                    sinResultados.classList.add('d-none');
                }
                
                // Mostrar/ocultar botón limpiar
                if (termino === '') {
                    btnLimpiar.style.display = 'none';
                } else {
                    btnLimpiar.style.display = 'block';
                }
            }
            
            // Función para limpiar la búsqueda
            function limpiarBusqueda() {
                inputBusqueda.value = '';
                buscarSintomas();
                inputBusqueda.focus();
            }
            
            // Event listeners
            if (inputBusqueda) {
                inputBusqueda.addEventListener('input', buscarSintomas);
                inputBusqueda.addEventListener('keyup', function(e) {
                    if (e.key === 'Escape') {
                        limpiarBusqueda();
                    }
                });
            }
            
            if (btnLimpiar) {
                btnLimpiar.addEventListener('click', limpiarBusqueda);
                btnLimpiar.style.display = 'none'; // Ocultar inicialmente
            }
            
            // Atajos de teclado
            document.addEventListener('keydown', function(e) {
                // Ctrl+F o Cmd+F para enfocar búsqueda
                if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
                    e.preventDefault();
                    if (inputBusqueda) {
                        inputBusqueda.focus();
                        inputBusqueda.select();
                    }
                }
            });
            
            // Tooltip para ayuda
            if (inputBusqueda) {
                inputBusqueda.setAttribute('title', 'Buscar por número de síntoma o nombre. Usa Ctrl+F para enfocar rápidamente.');
            }
        });
    </script>
</body>
</html>
