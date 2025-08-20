<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuevo Síntoma - Sistema Diagnóstico Médico</title>
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
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-plus me-2"></i>Registrar Nuevo Síntoma
                        </h4>
                    </div>
                    <div class="card-body">
                        <form method="post" action="sintomas">
                            <input type="hidden" name="action" value="create">
                            
                            <div class="mb-3">
                                <label for="nombre" class="form-label">
                                    <i class="fas fa-clipboard-list me-2"></i>Nombre del Síntoma *
                                </label>
                                <input type="text" class="form-control" id="nombre" name="nombre" 
                                       placeholder="Ej: Fiebre, Tos, Dolor de cabeza..." 
                                       required maxlength="100" minlength="3">
                                <div class="form-text">
                                    Ingrese un nombre descriptivo para el síntoma (mínimo 3 caracteres).
                                </div>
                            </div>
                            
                            <div class="alert alert-info">
                                <h6><i class="fas fa-info-circle me-2"></i>Criterios de Validación:</h6>
                                <ul class="mb-0">
                                    <li>El nombre no puede estar vacío</li>
                                    <li>Debe tener al menos 3 caracteres</li>
                                    <li>No se pueden registrar síntomas duplicados</li>
                                    <li>Máximo 10 síntomas en total</li>
                                </ul>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="sintomas" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times me-2"></i>Cancelar
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save me-2"></i>Guardar Síntoma
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Información adicional -->
                <div class="card mt-4 border-warning">
                    <div class="card-header bg-warning text-dark">
                        <h6 class="mb-0"><i class="fas fa-lightbulb me-2"></i>Consejos</h6>
                    </div>
                    <div class="card-body">
                        <p class="mb-2">Ejemplos de síntomas comunes:</p>
                        <div class="row">
                            <div class="col-6">
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-thermometer-half text-danger me-2"></i>Fiebre</li>
                                    <li><i class="fas fa-head-side-cough text-warning me-2"></i>Tos</li>
                                    <li><i class="fas fa-tired text-info me-2"></i>Fatiga</li>
                                </ul>
                            </div>
                            <div class="col-6">
                                <ul class="list-unstyled">
                                    <li><i class="fas fa-brain text-primary me-2"></i>Dolor de cabeza</li>
                                    <li><i class="fas fa-stomach text-success me-2"></i>Náuseas</li>
                                    <li><i class="fas fa-lungs text-secondary me-2"></i>Dificultad respiratoria</li>
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
        // Auto-focus en el campo de nombre
        document.getElementById('nombre').focus();
    </script>
</body>
</html>
