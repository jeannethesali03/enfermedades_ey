package com.mycompany.diagnosticomedico2.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Enfermedad implements Serializable {
    private int id;
    private String nombre;
    private List<Integer> sintomasIds;
    
    public Enfermedad() {
        this.sintomasIds = new ArrayList<>();
    }
    
    public Enfermedad(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
        this.sintomasIds = new ArrayList<>();
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public List<Integer> getSintomasIds() {
        return sintomasIds;
    }
    
    public void setSintomasIds(List<Integer> sintomasIds) {
        this.sintomasIds = sintomasIds;
    }
    
    public void addSintomaId(int sintomaId) {
        if (!sintomasIds.contains(sintomaId)) {
            sintomasIds.add(sintomaId);
        }
    }
    
    public boolean tieneSintoma(int sintomaId) {
        return sintomasIds.contains(sintomaId);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Enfermedad enfermedad = (Enfermedad) obj;
        return id == enfermedad.id || (nombre != null && nombre.equalsIgnoreCase(enfermedad.nombre));
    }
    
    @Override
    public int hashCode() {
        return nombre != null ? nombre.toLowerCase().hashCode() : 0;
    }
    
    @Override
    public String toString() {
        return "Enfermedad{id=" + id + ", nombre='" + nombre + "', sintomas=" + sintomasIds.size() + "}";
    }
}
