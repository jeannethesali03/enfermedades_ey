package com.mycompany.diagnosticomedico2.servlet;

import com.mycompany.diagnosticomedico2.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.List;

@WebServlet(name = "ReporteServlet", urlPatterns = {"/reportes"})
public class ReporteServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "menu";
        
        switch (action) {
            case "menu":
                mostrarMenuReportes(request, response);
                break;
            case "global":
                generarReporteGlobal(request, response);
                break;
            case "paciente":
                String pacienteId = request.getParameter("pacienteId");
                if (pacienteId != null && !pacienteId.trim().isEmpty()) {
                    generarReportePaciente(request, response, pacienteId);
                } else {
                    mostrarSeleccionPaciente(request, response);
                }
                break;
            case "estadisticasEnfermedades":
                mostrarEstadisticasEnfermedades(request, response);
                break;
            case "pacientesEnfermedad":
                String enfermedadNombre = request.getParameter("enfermedadNombre");
                if (enfermedadNombre != null && !enfermedadNombre.trim().isEmpty()) {
                    mostrarPacientesEnfermedad(request, response, enfermedadNombre);
                } else {
                    mostrarEstadisticasEnfermedades(request, response);
                }
                break;
            default:
                mostrarMenuReportes(request, response);
                break;
        }
    }
    
    private void mostrarMenuReportes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        if (pacientes == null) {
            pacientes = new ArrayList<>();
        }
        
        request.setAttribute("pacientes", pacientes);
        request.getRequestDispatcher("/WEB-INF/jsp/reportes/menu.jsp").forward(request, response);
    }
    
    private void mostrarSeleccionPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        if (pacientes == null) {
            pacientes = new ArrayList<>();
        }
        
        // Filtrar solo pacientes con diagnósticos
        List<Paciente> pacientesConDiagnosticos = new ArrayList<>();
        for (Paciente p : pacientes) {
            if (!p.getDiagnosticos().isEmpty()) {
                pacientesConDiagnosticos.add(p);
            }
        }
        
        request.setAttribute("pacientes", pacientesConDiagnosticos);
        request.getRequestDispatcher("/WEB-INF/jsp/reportes/seleccionPaciente.jsp").forward(request, response);
    }
    
    private void generarReporteGlobal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        @SuppressWarnings("unchecked")
        List<Enfermedad> enfermedades = (List<Enfermedad>) session.getAttribute("enfermedades");
        
        if (pacientes == null) pacientes = new ArrayList<>();
        if (sintomas == null) sintomas = new ArrayList<>();
        if (enfermedades == null) enfermedades = new ArrayList<>();
        
        // Generar estadísticas
        int totalDiagnosticos = 0;
        int diagnosticosExactos = 0;
        int diagnosticosAproximados = 0;
        
        for (Paciente paciente : pacientes) {
            for (Diagnostico diagnostico : paciente.getDiagnosticos()) {
                totalDiagnosticos++;
                if (diagnostico.isEsExacto()) {
                    diagnosticosExactos++;
                } else {
                    diagnosticosAproximados++;
                }
            }
        }
        
        // Estadísticas de enfermedades más diagnosticadas
        Map<String, Integer> conteoEnfermedades = new HashMap<>();
        for (Paciente paciente : pacientes) {
            for (Diagnostico diagnostico : paciente.getDiagnosticos()) {
                if (diagnostico.isEsExacto()) {
                    conteoEnfermedades.merge(diagnostico.getEnfermedadDiagnosticada(), 1, Integer::sum);
                }
            }
        }
        
        List<Map.Entry<String, Integer>> enfermedadesOrdenadas = new ArrayList<>(conteoEnfermedades.entrySet());
        enfermedadesOrdenadas.sort((e1, e2) -> e2.getValue().compareTo(e1.getValue()));
        
        // Pasar datos a la vista
        request.setAttribute("pacientes", pacientes);
        request.setAttribute("sintomas", sintomas);
        request.setAttribute("enfermedades", enfermedades);
        request.setAttribute("totalDiagnosticos", totalDiagnosticos);
        request.setAttribute("diagnosticosExactos", diagnosticosExactos);
        request.setAttribute("diagnosticosAproximados", diagnosticosAproximados);
        request.setAttribute("enfermedadesOrdenadas", enfermedadesOrdenadas);
        request.setAttribute("fechaGeneracion", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()));
        
        request.getRequestDispatcher("/WEB-INF/jsp/reportes/reporteGlobal.jsp").forward(request, response);
    }
    
    private void generarReportePaciente(HttpServletRequest request, HttpServletResponse response, String pacienteId)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        
        if (pacientes == null) pacientes = new ArrayList<>();
        if (sintomas == null) sintomas = new ArrayList<>();
        
        // Buscar paciente
        Paciente paciente = pacientes.stream()
                .filter(p -> p.getId().equals(pacienteId))
                .findFirst()
                .orElse(null);
        
        if (paciente == null) {
            request.setAttribute("mensaje", "Paciente no encontrado.");
            request.setAttribute("tipoMensaje", "error");
            mostrarMenuReportes(request, response);
            return;
        }
        
        // Pasar datos a la vista
        request.setAttribute("paciente", paciente);
        request.setAttribute("sintomas", sintomas);
        request.setAttribute("fechaGeneracion", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()));
        
        request.getRequestDispatcher("/WEB-INF/jsp/reportes/reportePaciente.jsp").forward(request, response);
    }
    
    private void mostrarEstadisticasEnfermedades(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        @SuppressWarnings("unchecked")
        List<Enfermedad> enfermedades = (List<Enfermedad>) session.getAttribute("enfermedades");
        
        if (pacientes == null) pacientes = new ArrayList<>();
        if (enfermedades == null) enfermedades = new ArrayList<>();
        
        // Crear mapa de estadísticas por enfermedad
        Map<String, EnfermedadEstadistica> estadisticas = new HashMap<>();
        
        // Inicializar estadísticas para todas las enfermedades registradas
        for (Enfermedad enfermedad : enfermedades) {
            estadisticas.put(enfermedad.getNombre(), new EnfermedadEstadistica(enfermedad.getNombre()));
        }
        
        // Analizar diagnósticos
        for (Paciente paciente : pacientes) {
            for (Diagnostico diagnostico : paciente.getDiagnosticos()) {
                String enfermedadNombre = diagnostico.getEnfermedadDiagnosticada();
                
                // Si la enfermedad no existe en el mapa, crearla
                estadisticas.putIfAbsent(enfermedadNombre, new EnfermedadEstadistica(enfermedadNombre));
                
                EnfermedadEstadistica stat = estadisticas.get(enfermedadNombre);
                stat.agregarDiagnostico(paciente, diagnostico);
            }
        }
        
        // Convertir a lista y ordenar por total de casos
        List<EnfermedadEstadistica> listaEstadisticas = new ArrayList<>(estadisticas.values());
        listaEstadisticas.sort((e1, e2) -> Integer.compare(e2.getTotalCasos(), e1.getTotalCasos()));
        
        request.setAttribute("estadisticasEnfermedades", listaEstadisticas);
        request.setAttribute("fechaGeneracion", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()));
        
        request.getRequestDispatcher("/WEB-INF/jsp/reportes/estadisticasEnfermedades.jsp").forward(request, response);
    }
    
    private void mostrarPacientesEnfermedad(HttpServletRequest request, HttpServletResponse response, String enfermedadNombre)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        if (pacientes == null) pacientes = new ArrayList<>();
        
        // Recopilar todos los pacientes que tienen esta enfermedad
        List<PacienteDiagnosticoDetalle> pacientesConEnfermedad = new ArrayList<>();
        
        for (Paciente paciente : pacientes) {
            for (Diagnostico diagnostico : paciente.getDiagnosticos()) {
                if (diagnostico.getEnfermedadDiagnosticada().equals(enfermedadNombre)) {
                    double porcentaje = 100.0; // Para diagnósticos exactos
                    
                    // Si es aproximado, buscar el porcentaje en los resultados aproximados
                    if (!diagnostico.isEsExacto() && diagnostico.getResultadosAproximados() != null) {
                        for (ResultadoDiagnostico resultado : diagnostico.getResultadosAproximados()) {
                            if (resultado.getEnfermedad().equals(enfermedadNombre)) {
                                porcentaje = resultado.getPorcentajeCoincidencia();
                                break;
                            }
                        }
                    }
                    
                    pacientesConEnfermedad.add(new PacienteDiagnosticoDetalle(paciente, diagnostico, porcentaje));
                }
            }
        }
        
        // Ordenar por porcentaje (mayor a menor) y luego por fecha
        pacientesConEnfermedad.sort((pd1, pd2) -> {
            int porcentajeComp = Double.compare(pd2.getPorcentaje(), pd1.getPorcentaje());
            if (porcentajeComp != 0) return porcentajeComp;
            return pd2.getDiagnostico().getFecha().compareTo(pd1.getDiagnostico().getFecha());
        });
        
        request.setAttribute("enfermedadNombre", enfermedadNombre);
        request.setAttribute("pacientesConEnfermedad", pacientesConEnfermedad);
        request.setAttribute("fechaGeneracion", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()));
        
        request.getRequestDispatcher("/WEB-INF/jsp/reportes/pacientesEnfermedad.jsp").forward(request, response);
    }
    
    // Clases auxiliares para manejar estadísticas
    public static class EnfermedadEstadistica {
        private String nombre;
        private int casosExactos;
        private int casosAproximados;
        private List<PacienteDiagnostico> pacientes;
        
        public EnfermedadEstadistica(String nombre) {
            this.nombre = nombre;
            this.casosExactos = 0;
            this.casosAproximados = 0;
            this.pacientes = new ArrayList<>();
        }
        
        public void agregarDiagnostico(Paciente paciente, Diagnostico diagnostico) {
            pacientes.add(new PacienteDiagnostico(paciente, diagnostico));
            if (diagnostico.isEsExacto()) {
                casosExactos++;
            } else {
                casosAproximados++;
            }
        }
        
        public String getNombre() { return nombre; }
        public int getCasosExactos() { return casosExactos; }
        public int getCasosAproximados() { return casosAproximados; }
        public int getTotalCasos() { return casosExactos + casosAproximados; }
        public List<PacienteDiagnostico> getPacientes() { return pacientes; }
    }
    
    public static class PacienteDiagnostico {
        private Paciente paciente;
        private Diagnostico diagnostico;
        
        public PacienteDiagnostico(Paciente paciente, Diagnostico diagnostico) {
            this.paciente = paciente;
            this.diagnostico = diagnostico;
        }
        
        public Paciente getPaciente() { return paciente; }
        public Diagnostico getDiagnostico() { return diagnostico; }
    }
    
    public static class PacienteDiagnosticoDetalle {
        private Paciente paciente;
        private Diagnostico diagnostico;
        private double porcentaje;
        
        public PacienteDiagnosticoDetalle(Paciente paciente, Diagnostico diagnostico, double porcentaje) {
            this.paciente = paciente;
            this.diagnostico = diagnostico;
            this.porcentaje = porcentaje;
        }
        
        public Paciente getPaciente() { return paciente; }
        public Diagnostico getDiagnostico() { return diagnostico; }
        public double getPorcentaje() { return porcentaje; }
    }
}
