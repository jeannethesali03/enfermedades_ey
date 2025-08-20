package com.mycompany.diagnosticomedico2.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class Diagnostico implements Serializable {
    private Date fecha;
    private String pacienteId;
    private boolean esExacto;
    private String enfermedadDiagnosticada;
    private List<ResultadoDiagnostico> resultadosAproximados;
    private List<Integer> sintomasSeleccionados;
    
    public Diagnostico() {
        this.fecha = new Date();
    }
    
    public Diagnostico(String pacienteId, boolean esExacto, String enfermedadDiagnosticada) {
        this.fecha = new Date();
        this.pacienteId = pacienteId;
        this.esExacto = esExacto;
        this.enfermedadDiagnosticada = enfermedadDiagnosticada;
    }
    
    public Date getFecha() {
        return fecha;
    }
    
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
    
    public String getPacienteId() {
        return pacienteId;
    }
    
    public void setPacienteId(String pacienteId) {
        this.pacienteId = pacienteId;
    }
    
    public boolean isEsExacto() {
        return esExacto;
    }
    
    public void setEsExacto(boolean esExacto) {
        this.esExacto = esExacto;
    }
    
    public String getEnfermedadDiagnosticada() {
        return enfermedadDiagnosticada;
    }
    
    public void setEnfermedadDiagnosticada(String enfermedadDiagnosticada) {
        this.enfermedadDiagnosticada = enfermedadDiagnosticada;
    }
    
    public List<ResultadoDiagnostico> getResultadosAproximados() {
        return resultadosAproximados;
    }
    
    public void setResultadosAproximados(List<ResultadoDiagnostico> resultadosAproximados) {
        this.resultadosAproximados = resultadosAproximados;
    }
    
    public List<Integer> getSintomasSeleccionados() {
        return sintomasSeleccionados;
    }
    
    public void setSintomasSeleccionados(List<Integer> sintomasSeleccionados) {
        this.sintomasSeleccionados = sintomasSeleccionados;
    }
    
    // Método auxiliar para obtener los nombres de los síntomas
    public List<String> getSintomasIngresados() {
        // Este método debería ser llamado con la lista de síntomas del sistema
        // Por ahora retornamos una lista vacía, será implementado en la JSP
        return new java.util.ArrayList<>();
    }
    
    @Override
    public String toString() {
        return "Diagnostico{fecha=" + fecha + ", pacienteId='" + pacienteId + "', esExacto=" + esExacto + 
               ", enfermedad='" + enfermedadDiagnosticada + "'}";
    }
}
