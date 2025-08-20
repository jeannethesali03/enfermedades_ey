package com.mycompany.diagnosticomedico2.model;

import java.io.Serializable;

public class Sintoma implements Serializable {
    private int id;
    private String nombre;
    
    public Sintoma() {
    }
    
    public Sintoma(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
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
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Sintoma sintoma = (Sintoma) obj;
        return id == sintoma.id || (nombre != null && nombre.equalsIgnoreCase(sintoma.nombre));
    }
    
    @Override
    public int hashCode() {
        return nombre != null ? nombre.toLowerCase().hashCode() : 0;
    }
    
    @Override
    public String toString() {
        return "Sintoma{id=" + id + ", nombre='" + nombre + "'}";
    }
}
