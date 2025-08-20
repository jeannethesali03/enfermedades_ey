package com.mycompany.diagnosticomedico2.servlet;

import com.mycompany.diagnosticomedico2.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "DiagnosticoServlet", urlPatterns = {"/diagnostico"})
public class DiagnosticoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "form";
        
        switch (action) {
            case "form":
                mostrarFormularioDiagnostico(request, response);
                break;
            case "historial":
                mostrarHistorial(request, response);
                break;
            default:
                mostrarFormularioDiagnostico(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("realizar".equals(action)) {
            realizarDiagnostico(request, response);
        }
    }
    
    private void mostrarFormularioDiagnostico(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        @SuppressWarnings("unchecked")
        List<Enfermedad> enfermedades = (List<Enfermedad>) session.getAttribute("enfermedades");
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        String mensaje = "";
        String tipoMensaje = "";
        
        if (sintomas == null || sintomas.isEmpty()) {
            mensaje = "Debe registrar síntomas antes de realizar un diagnóstico.";
            tipoMensaje = "error";
        } else if (enfermedades == null || enfermedades.isEmpty()) {
            mensaje = "Debe registrar enfermedades antes de realizar un diagnóstico.";
            tipoMensaje = "error";
        } else if (pacientes == null || pacientes.isEmpty()) {
            mensaje = "Debe registrar pacientes antes de realizar un diagnóstico.";
            tipoMensaje = "error";
        }
        
        request.setAttribute("sintomas", sintomas != null ? sintomas : new ArrayList<>());
        request.setAttribute("pacientes", pacientes != null ? pacientes : new ArrayList<>());
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", tipoMensaje);
        
        request.getRequestDispatcher("/WEB-INF/jsp/diagnostico/formulario.jsp").forward(request, response);
    }
    
    private void realizarDiagnostico(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        @SuppressWarnings("unchecked")
        List<Enfermedad> enfermedades = (List<Enfermedad>) session.getAttribute("enfermedades");
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        String pacienteId = request.getParameter("pacienteId");
        String[] sintomasSeleccionados = request.getParameterValues("sintomas");
        
        String mensaje = "";
        String tipoMensaje = "";
        
        // Validaciones
        if (pacienteId == null || pacienteId.trim().isEmpty()) {
            mensaje = "Debe seleccionar un paciente.";
            tipoMensaje = "error";
        } else if (sintomasSeleccionados == null || sintomasSeleccionados.length == 0) {
            mensaje = "Debe seleccionar al menos un síntoma.";
            tipoMensaje = "error";
        } else {
            // Buscar paciente
            Paciente paciente = pacientes.stream()
                    .filter(p -> p.getId().equals(pacienteId))
                    .findFirst()
                    .orElse(null);
            
            if (paciente == null) {
                mensaje = "Paciente no encontrado.";
                tipoMensaje = "error";
            } else {
                // Convertir síntomas seleccionados a lista de enteros
                List<Integer> sintomasIds = Arrays.stream(sintomasSeleccionados)
                        .map(Integer::parseInt)
                        .collect(Collectors.toList());
                
                // Realizar diagnóstico
                Diagnostico diagnostico = realizarDiagnosticoLogica(sintomasIds, enfermedades, sintomas);
                diagnostico.setPacienteId(pacienteId);
                diagnostico.setSintomasSeleccionados(sintomasIds);
                
                // Agregar diagnóstico al paciente
                paciente.addDiagnostico(diagnostico);
                
                // Preparar resultado para mostrar
                request.setAttribute("diagnostico", diagnostico);
                request.setAttribute("paciente", paciente);
                request.setAttribute("sintomas", sintomas);
                request.setAttribute("sintomasSeleccionados", sintomasIds);
                
                request.getRequestDispatcher("/WEB-INF/jsp/diagnostico/resultado.jsp").forward(request, response);
                return;
            }
        }
        
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", tipoMensaje);
        request.setAttribute("sintomas", sintomas != null ? sintomas : new ArrayList<>());
        request.setAttribute("pacientes", pacientes != null ? pacientes : new ArrayList<>());
        
        request.getRequestDispatcher("/WEB-INF/jsp/diagnostico/formulario.jsp").forward(request, response);
    }
    
    private Diagnostico realizarDiagnosticoLogica(List<Integer> sintomasSeleccionados, 
                                                 List<Enfermedad> enfermedades, 
                                                 List<Sintoma> sintomas) {
        
        Diagnostico diagnostico = new Diagnostico();
        
        // Buscar coincidencia exacta
        for (Enfermedad enfermedad : enfermedades) {
            Set<Integer> sintomasEnfermedad = new HashSet<>(enfermedad.getSintomasIds());
            Set<Integer> sintomasSeleccionadosSet = new HashSet<>(sintomasSeleccionados);
            
            if (sintomasEnfermedad.equals(sintomasSeleccionadosSet)) {
                // Coincidencia exacta
                diagnostico.setEsExacto(true);
                diagnostico.setEnfermedadDiagnosticada(enfermedad.getNombre());
                return diagnostico;
            }
        }
        
        // No hay coincidencia exacta, calcular aproximadas
        List<ResultadoDiagnostico> resultados = new ArrayList<>();
        
        for (Enfermedad enfermedad : enfermedades) {
            int coincidencias = 0;
            for (Integer sintomaId : sintomasSeleccionados) {
                if (enfermedad.getSintomasIds().contains(sintomaId)) {
                    coincidencias++;
                }
            }
            
            if (coincidencias > 0) {
                double porcentaje = (double) coincidencias / sintomasSeleccionados.size() * 100;
                ResultadoDiagnostico resultado = new ResultadoDiagnostico(
                    enfermedad.getNombre(), 
                    porcentaje, 
                    coincidencias, 
                    sintomasSeleccionados.size()
                );
                resultados.add(resultado);
            }
        }
        
        // Ordenar por porcentaje de confianza (descendente)
        resultados.sort((r1, r2) -> Double.compare(r2.getPorcentajeConfianza(), r1.getPorcentajeConfianza()));
        
        // Tomar las 3 mejores (o menos si no hay suficientes)
        List<ResultadoDiagnostico> top3 = resultados.stream()
                .limit(3)
                .collect(Collectors.toList());
        
        diagnostico.setEsExacto(false);
        diagnostico.setResultadosAproximados(top3);
        
        if (top3.isEmpty()) {
            diagnostico.setEnfermedadDiagnosticada("No se puede emitir un diagnóstico fiable con la información proporcionada.");
        } else {
            diagnostico.setEnfermedadDiagnosticada("Diagnóstico no concluyente");
        }
        
        return diagnostico;
    }
    
    private void mostrarHistorial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        
        if (pacientes == null) {
            pacientes = new ArrayList<>();
        }
        
        if (sintomas == null) {
            sintomas = new ArrayList<>();
        }
        
        // Crear lista de todos los diagnósticos con información del paciente
        List<Map<String, Object>> historialCompleto = new ArrayList<>();
        
        for (Paciente paciente : pacientes) {
            for (Diagnostico diagnostico : paciente.getDiagnosticos()) {
                Map<String, Object> item = new HashMap<>();
                item.put("paciente", paciente);
                item.put("diagnostico", diagnostico);
                historialCompleto.add(item);
            }
        }
        
        // Ordenar por fecha (más reciente primero)
        historialCompleto.sort((a, b) -> {
            Diagnostico d1 = (Diagnostico) a.get("diagnostico");
            Diagnostico d2 = (Diagnostico) b.get("diagnostico");
            return d2.getFecha().compareTo(d1.getFecha());
        });
        
        request.setAttribute("historial", historialCompleto);
        request.setAttribute("sintomas", sintomas);
        request.getRequestDispatcher("/WEB-INF/jsp/diagnostico/historial.jsp").forward(request, response);
    }
}
