package com.mycompany.diagnosticomedico2.servlet;

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

@WebServlet(name = "SintomaServlet", urlPatterns = {"/sintomas"})
public class SintomaServlet extends HttpServlet {
    
    private static final int MAX_SINTOMAS = 10;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "new":
                request.getRequestDispatcher("/WEB-INF/jsp/sintomas/nuevo.jsp").forward(request, response);
                break;
            case "list":
            default:
                listarSintomas(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            crearSintoma(request, response);
        } else if ("delete".equals(action)) {
            eliminarSintoma(request, response);
        }
    }
    
    private void listarSintomas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        
        if (sintomas == null) {
            sintomas = new ArrayList<>();
            session.setAttribute("sintomas", sintomas);
        }
        
        request.setAttribute("sintomas", sintomas);
        request.setAttribute("maxSintomas", MAX_SINTOMAS);
        request.getRequestDispatcher("/WEB-INF/jsp/sintomas/lista.jsp").forward(request, response);
    }
    
    private void crearSintoma(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        
        if (sintomas == null) {
            sintomas = new ArrayList<>();
            session.setAttribute("sintomas", sintomas);
        }
        
        String nombre = request.getParameter("nombre");
        String mensaje = "";
        String tipoMensaje = "";
        
        // Validaciones
        if (nombre == null || nombre.trim().isEmpty()) {
            mensaje = "El nombre del síntoma no puede estar vacío.";
            tipoMensaje = "error";
        } else if (nombre.trim().length() < 3) {
            mensaje = "El nombre del síntoma debe tener al menos 3 caracteres.";
            tipoMensaje = "error";
        } else if (sintomas.size() >= MAX_SINTOMAS) {
            mensaje = "No se pueden registrar más de " + MAX_SINTOMAS + " síntomas.";
            tipoMensaje = "error";
        } else {
            // Verificar duplicados
            boolean existe = sintomas.stream()
                    .anyMatch(s -> s.getNombre().equalsIgnoreCase(nombre.trim()));
            
            if (existe) {
                mensaje = "Ya existe un síntoma con ese nombre.";
                tipoMensaje = "error";
            } else {
                // Crear nuevo síntoma
                int nuevoId = sintomas.isEmpty() ? 1 : 
                    sintomas.stream().mapToInt(Sintoma::getId).max().orElse(0) + 1;
                
                Sintoma nuevoSintoma = new Sintoma(nuevoId, nombre.trim());
                sintomas.add(nuevoSintoma);
                
                mensaje = "Síntoma registrado exitosamente.";
                tipoMensaje = "success";
            }
        }
        
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", tipoMensaje);
        request.setAttribute("sintomas", sintomas);
        request.setAttribute("maxSintomas", MAX_SINTOMAS);
        
        request.getRequestDispatcher("/WEB-INF/jsp/sintomas/lista.jsp").forward(request, response);
    }
    
    private void eliminarSintoma(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Sintoma> sintomas = (List<Sintoma>) session.getAttribute("sintomas");
        
        if (sintomas == null) {
            sintomas = new ArrayList<>();
            session.setAttribute("sintomas", sintomas);
        }
        
        String idStr = request.getParameter("id");
        String mensaje = "";
        String tipoMensaje = "";
        
        try {
            int id = Integer.parseInt(idStr);
            boolean eliminado = sintomas.removeIf(s -> s.getId() == id);
            
            if (eliminado) {
                mensaje = "Síntoma eliminado exitosamente.";
                tipoMensaje = "success";
            } else {
                mensaje = "No se encontró el síntoma a eliminar.";
                tipoMensaje = "error";
            }
        } catch (NumberFormatException e) {
            mensaje = "ID de síntoma inválido.";
            tipoMensaje = "error";
        }
        
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", tipoMensaje);
        request.setAttribute("sintomas", sintomas);
        request.setAttribute("maxSintomas", MAX_SINTOMAS);
        
        request.getRequestDispatcher("/WEB-INF/jsp/sintomas/lista.jsp").forward(request, response);
    }
}
