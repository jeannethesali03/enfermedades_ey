package com.mycompany.diagnosticomedico2.model;

import java.io.Serializable;

public class ResultadoDiagnostico implements Serializable {
    private String nombreEnfermedad;
    private double porcentajeConfianza;
    private int sintomasCoincidentes;
    private int totalSintomas;
    
    public ResultadoDiagnostico() {
    }
    
    public ResultadoDiagnostico(String nombreEnfermedad, double porcentajeConfianza, int sintomasCoincidentes, int totalSintomas) {
        this.nombreEnfermedad = nombreEnfermedad;
        this.porcentajeConfianza = porcentajeConfianza;
        this.sintomasCoincidentes = sintomasCoincidentes;
        this.totalSintomas = totalSintomas;
    }
    
    public String getNombreEnfermedad() {
        return nombreEnfermedad;
    }
    
    public void setNombreEnfermedad(String nombreEnfermedad) {
        this.nombreEnfermedad = nombreEnfermedad;
    }
    
    public double getPorcentajeConfianza() {
        return porcentajeConfianza;
    }
    
    public void setPorcentajeConfianza(double porcentajeConfianza) {
        this.porcentajeConfianza = porcentajeConfianza;
    }
    
    public int getSintomasCoincidentes() {
        return sintomasCoincidentes;
    }
    
    public void setSintomasCoincidentes(int sintomasCoincidentes) {
        this.sintomasCoincidentes = sintomasCoincidentes;
    }
    
    public int getTotalSintomas() {
        return totalSintomas;
    }
    
    public void setTotalSintomas(int totalSintomas) {
        this.totalSintomas = totalSintomas;
    }
    
    @Override
    public String toString() {
        return "ResultadoDiagnostico{enfermedad='" + nombreEnfermedad + "', confianza=" + porcentajeConfianza + "%}";
    }
}
