package com.mycompany.diagnosticomedico2.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Paciente implements Serializable {
    private String id;
    private String nombre;
    private int edad;
    private List<Diagnostico> diagnosticos;
    
    public Paciente() {
        this.diagnosticos = new ArrayList<>();
    }
    
    public Paciente(String id, String nombre, int edad) {
        this.id = id;
        this.nombre = nombre;
        this.edad = edad;
        this.diagnosticos = new ArrayList<>();
    }
    
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public int getEdad() {
        return edad;
    }
    
    public void setEdad(int edad) {
        this.edad = edad;
    }
    
    public List<Diagnostico> getDiagnosticos() {
        return diagnosticos;
    }
    
    public void setDiagnosticos(List<Diagnostico> diagnosticos) {
        this.diagnosticos = diagnosticos;
    }
    
    public void addDiagnostico(Diagnostico diagnostico) {
        this.diagnosticos.add(diagnostico);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Paciente paciente = (Paciente) obj;
        return id != null && id.equalsIgnoreCase(paciente.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.toLowerCase().hashCode() : 0;
    }
    
    @Override
    public String toString() {
        return "Paciente{id='" + id + "', nombre='" + nombre + "', edad=" + edad + ", diagnosticos=" + diagnosticos.size() + "}";
    }
}
