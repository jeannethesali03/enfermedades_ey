package com.mycompany.diagnosticomedico2.model;

import java.io.Serializable;

public class PacienteDiagnosticoDetalle implements Serializable {
    private Paciente paciente;
    private Diagnostico diagnostico;
    private double porcentaje;
    
    public PacienteDiagnosticoDetalle() {
    }
    
    public PacienteDiagnosticoDetalle(Paciente paciente, Diagnostico diagnostico, double porcentaje) {
        this.paciente = paciente;
        this.diagnostico = diagnostico;
        this.porcentaje = porcentaje;
    }
    
    public Paciente getPaciente() {
        return paciente;
    }
    
    public void setPaciente(Paciente paciente) {
        this.paciente = paciente;
    }
    
    public Diagnostico getDiagnostico() {
        return diagnostico;
    }
    
    public void setDiagnostico(Diagnostico diagnostico) {
        this.diagnostico = diagnostico;
    }
    
    public double getPorcentaje() {
        return porcentaje;
    }
    
    public void setPorcentaje(double porcentaje) {
        this.porcentaje = porcentaje;
    }
    
    @Override
    public String toString() {
        return "PacienteDiagnosticoDetalle{" +
               "paciente=" + (paciente != null ? paciente.getId() : "null") +
               ", diagnostico=" + (diagnostico != null ? diagnostico.getFecha() : "null") +
               ", porcentaje=" + porcentaje +
               '}';
    }
}
