package com.mycompany.diagnosticomedico2.servlet;

import com.mycompany.diagnosticomedico2.model.Paciente;
import com.mycompany.diagnosticomedico2.model.Diagnostico;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "PacienteServlet", urlPatterns = {"/pacientes"})
public class PacienteServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "new":
                request.getRequestDispatcher("/WEB-INF/jsp/pacientes/nuevo.jsp").forward(request, response);
                break;
            case "edit":
                editarPaciente(request, response);
                break;
            case "view":
                verPaciente(request, response);
                break;
            case "list":
            default:
                listarPacientes(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "create":
                crearPaciente(request, response);
                break;
            case "update":
                actualizarPaciente(request, response);
                break;
            case "delete":
                eliminarPaciente(request, response);
                break;
            default:
                listarPacientes(request, response);
                break;
        }
    }
    
    private void listarPacientes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        if (pacientes == null) {
            pacientes = new ArrayList<>();
            session.setAttribute("pacientes", pacientes);
        }
        
        request.setAttribute("pacientes", pacientes);
        request.getRequestDispatcher("/WEB-INF/jsp/pacientes/lista.jsp").forward(request, response);
    }
    
    private void crearPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        if (pacientes == null) {
            pacientes = new ArrayList<>();
            session.setAttribute("pacientes", pacientes);
        }
        
        String id = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String edadStr = request.getParameter("edad");
        String mensaje = "";
        String tipoMensaje = "";
        
        // Validaciones
        if (id == null || id.trim().isEmpty()) {
            mensaje = "El DUI del paciente no puede estar vacío.";
            tipoMensaje = "error";
        } else if (!id.trim().matches("^[0-9]{8}-[0-9]$")) {
            mensaje = "El DUI debe tener el formato correcto: 12345678-9 (8 dígitos, guión, 1 dígito).";
            tipoMensaje = "error";
        } else if (nombre == null || nombre.trim().isEmpty()) {
            mensaje = "El nombre del paciente no puede estar vacío.";
            tipoMensaje = "error";
        } else if (nombre.trim().length() < 3) {
            mensaje = "El nombre del paciente debe tener al menos 3 caracteres.";
            tipoMensaje = "error";
        } else if (!nombre.trim().matches("^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\\s]+$")) {
            mensaje = "El nombre solo puede contener letras, espacios y acentos. No se permiten números ni símbolos.";
            tipoMensaje = "error";
        } else if (edadStr == null || edadStr.trim().isEmpty()) {
            mensaje = "La edad del paciente no puede estar vacía.";
            tipoMensaje = "error";
        } else {
            try {
                int edad = Integer.parseInt(edadStr.trim());
                
                if (edad < 0 || edad > 120) {
                    mensaje = "La edad debe estar entre 0 y 120 años.";
                    tipoMensaje = "error";
                } else {
                    // Verificar duplicados
                    boolean existe = pacientes.stream()
                            .anyMatch(p -> p.getId().equalsIgnoreCase(id.trim()));
                    
                    if (existe) {
                        mensaje = "Ya existe un paciente con ese ID.";
                        tipoMensaje = "error";
                    } else {
                        // Crear nuevo paciente
                        Paciente nuevoPaciente = new Paciente(id.trim(), nombre.trim(), edad);
                        pacientes.add(nuevoPaciente);
                        
                        mensaje = "Paciente registrado exitosamente.";
                        tipoMensaje = "success";
                    }
                }
            } catch (NumberFormatException e) {
                mensaje = "La edad debe ser un número válido.";
                tipoMensaje = "error";
            }
        }
        
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", tipoMensaje);
        request.setAttribute("pacientes", pacientes);
        
        request.getRequestDispatcher("/WEB-INF/jsp/pacientes/lista.jsp").forward(request, response);
    }
    
    private void editarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        if (pacientes == null) {
            pacientes = new ArrayList<>();
            session.setAttribute("pacientes", pacientes);
        }
        
        String id = request.getParameter("id");
        Paciente paciente = pacientes.stream()
                .filter(p -> p.getId().equals(id))
                .findFirst()
                .orElse(null);
        
        if (paciente == null) {
            request.setAttribute("mensaje", "Paciente no encontrado.");
            request.setAttribute("tipoMensaje", "error");
            listarPacientes(request, response);
            return;
        }
        
        request.setAttribute("paciente", paciente);
        request.getRequestDispatcher("/WEB-INF/jsp/pacientes/editar.jsp").forward(request, response);
    }
    
    private void actualizarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        if (pacientes == null) {
            pacientes = new ArrayList<>();
            session.setAttribute("pacientes", pacientes);
        }
        
        String id = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String edadStr = request.getParameter("edad");
        String mensaje = "";
        String tipoMensaje = "";
        
        Paciente paciente = pacientes.stream()
                .filter(p -> p.getId().equals(id))
                .findFirst()
                .orElse(null);
        
        if (paciente == null) {
            mensaje = "Paciente no encontrado.";
            tipoMensaje = "error";
        } else if (nombre == null || nombre.trim().isEmpty()) {
            mensaje = "El nombre del paciente no puede estar vacío.";
            tipoMensaje = "error";
        } else if (nombre.trim().length() < 3) {
            mensaje = "El nombre del paciente debe tener al menos 3 caracteres.";
            tipoMensaje = "error";
        } else if (!nombre.trim().matches("^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\\s]+$")) {
            mensaje = "El nombre solo puede contener letras, espacios y acentos. No se permiten números ni símbolos.";
            tipoMensaje = "error";
        } else if (edadStr == null || edadStr.trim().isEmpty()) {
            mensaje = "La edad del paciente no puede estar vacía.";
            tipoMensaje = "error";
        } else {
            try {
                int edad = Integer.parseInt(edadStr.trim());
                
                if (edad < 0 || edad > 120) {
                    mensaje = "La edad debe estar entre 0 y 120 años.";
                    tipoMensaje = "error";
                } else {
                    // Actualizar paciente
                    paciente.setNombre(nombre.trim());
                    paciente.setEdad(edad);
                    
                    mensaje = "Paciente actualizado exitosamente.";
                    tipoMensaje = "success";
                }
            } catch (NumberFormatException e) {
                mensaje = "La edad debe ser un número válido.";
                tipoMensaje = "error";
            }
        }
        
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", tipoMensaje);
        request.setAttribute("pacientes", pacientes);
        
        request.getRequestDispatcher("/WEB-INF/jsp/pacientes/lista.jsp").forward(request, response);
    }
    
    private void eliminarPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        if (pacientes == null) {
            pacientes = new ArrayList<>();
            session.setAttribute("pacientes", pacientes);
        }
        
        String id = request.getParameter("id");
        String mensaje = "";
        String tipoMensaje = "";
        
        boolean eliminado = pacientes.removeIf(p -> p.getId().equals(id));
        
        if (eliminado) {
            mensaje = "Paciente eliminado exitosamente.";
            tipoMensaje = "success";
        } else {
            mensaje = "No se encontró el paciente a eliminar.";
            tipoMensaje = "error";
        }
        
        request.setAttribute("mensaje", mensaje);
        request.setAttribute("tipoMensaje", tipoMensaje);
        request.setAttribute("pacientes", pacientes);
        
        request.getRequestDispatcher("/WEB-INF/jsp/pacientes/lista.jsp").forward(request, response);
    }
    
    private void verPaciente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Paciente> pacientes = (List<Paciente>) session.getAttribute("pacientes");
        
        if (pacientes == null) {
            pacientes = new ArrayList<>();
            session.setAttribute("pacientes", pacientes);
        }
        
        String id = request.getParameter("id");
        Paciente paciente = pacientes.stream()
                .filter(p -> p.getId().equals(id))
                .findFirst()
                .orElse(null);
        
        if (paciente == null) {
            request.setAttribute("mensaje", "Paciente no encontrado.");
            request.setAttribute("tipoMensaje", "error");
            listarPacientes(request, response);
            return;
        }
        
        request.setAttribute("paciente", paciente);
        request.getRequestDispatcher("/WEB-INF/jsp/pacientes/ver.jsp").forward(request, response);
    }
}
