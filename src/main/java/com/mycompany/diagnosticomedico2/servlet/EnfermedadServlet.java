package com.mycompany.diagnosticomedico2.servlet;

import com.mycompany.diagnosticomedico2.model.Enfermedad;
import com.mycompany.diagnosticomedico2.model.Sintoma;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "EnfermedadServlet", urlPatterns = {"/enfermedades"})
public class EnfermedadServlet extends HttpServlet {
    
    private static final int MAX_ENFERMEDADES = 10;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "new":
                mostrarFormularioNueva(request, response);
                break;
            case "list":
            default:
                listarEnfermedades(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            crearEnfermedad(request, response);
        } else if ("delete".equals(action)) {
            eliminarEnfermedad(request, response);
        }
    }
    
    private void mostrarFormularioNueva(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        
        if (sintomas == null || sintomas.isEmpty()) {
            request.setAttribute("mensaje", "Debe registrar síntomas antes de crear enfermedades.");
            request.setAttribute("tipoMensaje", "error");
            listarEnfermedades(request, response);
            return;
        }
        
        request.setAttribute("sintomas", sintomas);
        request.getRequestDispatcher("/WEB-INF/jsp/enfermedades/nueva.jsp").forward(request, response);
    }
    
    private void listarEnfermedades(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Enfermedad> enfermedades = (List<Enfermedad>) session.getAttribute("enfermedades");
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        
        if (enfermedades == null) {
            enfermedades = new ArrayList<>();
            session.setAttribute("enfermedades", enfermedades);
        }
        
        if (sintomas == null) {
            sintomas = new ArrayList<>();
            session.setAttribute("sintomas", sintomas);
        }
        
        request.setAttribute("enfermedades", enfermedades);
        request.setAttribute("sintomas", sintomas);
        request.setAttribute("maxEnfermedades", MAX_ENFERMEDADES);
        request.getRequestDispatcher("/WEB-INF/jsp/enfermedades/lista.jsp").forward(request, response);
    }
    
    private void crearEnfermedad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Enfermedad> enfermedades = (List<Enfermedad>) session.getAttribute("enfermedades");
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        
        if (enfermedades == null) {
            enfermedades = new ArrayList<>();
            session.setAttribute("enfermedades", enfermedades);
        }
        
        String nombre = request.getParameter("nombre");
        String[] sintomasSeleccionados = request.getParameterValues("sintomas");
        String mensaje = "";
        String tipoMensaje = "";
        
        // Validaciones
        if (nombre == null || nombre.trim().isEmpty()) {
            mensaje = "El nombre de la enfermedad no puede estar vacío.";
            tipoMensaje = "error";
        } else if (nombre.trim().length() < 3) {
            mensaje = "El nombre de la enfermedad debe tener al menos 3 caracteres.";
            tipoMensaje = "error";
        } else if (enfermedades.size() >= MAX_ENFERMEDADES) {
            mensaje = "No se pueden registrar más de " + MAX_ENFERMEDADES + " enfermedades.";
            tipoMensaje = "error";
        } else if (sintomasSeleccionados == null || sintomasSeleccionados.length == 0) {
            mensaje = "Debe seleccionar al menos un síntoma para la enfermedad.";
            tipoMensaje = "error";
        } else {
            // Verificar duplicados
            boolean existe = enfermedades.stream()
                    .anyMatch(e -> e.getNombre().equalsIgnoreCase(nombre.trim()));
            
            if (existe) {
                mensaje = "Ya existe una enfermedad con ese nombre.";
                tipoMensaje = "error";
            } else {
                // Crear nueva enfermedad
                int nuevoId = enfermedades.isEmpty() ? 1 : 
                    enfermedades.stream().mapToInt(Enfermedad::getId).max().orElse(0) + 1;
                
                Enfermedad nuevaEnfermedad = new Enfermedad(nuevoId, nombre.trim());
                
                // Agregar síntomas seleccionados
                for (String sintomaIdStr : sintomasSeleccionados) {
                    try {
                        int sintomaId = Integer.parseInt(sintomaIdStr);
                        nuevaEnfermedad.addSintomaId(sintomaId);
                    } catch (NumberFormatException e) {
                        // Ignorar IDs inválidos
                    }
                }
                
                enfermedades.add(nuevaEnfermedad);
                
                mensaje = "Enfermedad registrada exitosamente.";
                tipoMensaje = "success";
            }
        }
        
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", tipoMensaje);
        request.setAttribute("enfermedades", enfermedades);
        request.setAttribute("sintomas", sintomas);
        request.setAttribute("maxEnfermedades", MAX_ENFERMEDADES);
        
        request.getRequestDispatcher("/WEB-INF/jsp/enfermedades/lista.jsp").forward(request, response);
    }
    
    private void eliminarEnfermedad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Enfermedad> enfermedades = (List<Enfermedad>) session.getAttribute("enfermedades");
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        
        if (enfermedades == null) {
            enfermedades = new ArrayList<>();
            session.setAttribute("enfermedades", enfermedades);
        }
        
        String idStr = request.getParameter("id");
        String mensaje = "";
        String tipoMensaje = "";
        
        try {
            int id = Integer.parseInt(idStr);
            boolean eliminado = enfermedades.removeIf(e -> e.getId() == id);
            
            if (eliminado) {
                mensaje = "Enfermedad eliminada exitosamente.";
                tipoMensaje = "success";
            } else {
                mensaje = "No se encontró la enfermedad a eliminar.";
                tipoMensaje = "error";
            }
        } catch (NumberFormatException e) {
            mensaje = "ID de enfermedad inválido.";
            tipoMensaje = "error";
        }
        
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", tipoMensaje);
        request.setAttribute("enfermedades", enfermedades);
        request.setAttribute("sintomas", sintomas);
        request.setAttribute("maxEnfermedades", MAX_ENFERMEDADES);
        
        request.getRequestDispatcher("/WEB-INF/jsp/enfermedades/lista.jsp").forward(request, response);
    }
}
