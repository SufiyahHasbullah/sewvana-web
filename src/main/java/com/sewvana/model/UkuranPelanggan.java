package com.sewvana.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model untuk data ukuran badan pelanggan.
 * Setiap pelanggan hanya ada SATU rekod ukuran (UNIQUE pada pelanggan_id).
 */
public class UkuranPelanggan implements Serializable {

    private int id;
    private int pelangganId;

    // Ukuran Badan Utama (cm)
    private Double bahu;
    private Double dada;
    private Double pinggang;
    private Double pinggul;

    // Panjang
    private Double panjangBaju;
    private Double panjangLengan;
    private Double panjangSeluar;

    // Ukuran Tambahan
    private Double ukuranLeher;
    private Double ukuranLenganAtas;

    // Catatan & Metadata
    private String catatanUkuran;
    private String dikemasKiniOleh;   // "PELANGGAN" atau "PENJAHIT"
    private String namaPengemaSkini;
    private Timestamp tarikhKemaskini;
    private Timestamp tarikhCipta;

    public UkuranPelanggan() {}

    // ─── Getters & Setters ────────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPelangganId() { return pelangganId; }
    public void setPelangganId(int pelangganId) { this.pelangganId = pelangganId; }

    public Double getBahu() { return bahu; }
    public void setBahu(Double bahu) { this.bahu = bahu; }

    public Double getDada() { return dada; }
    public void setDada(Double dada) { this.dada = dada; }

    public Double getPinggang() { return pinggang; }
    public void setPinggang(Double pinggang) { this.pinggang = pinggang; }

    public Double getPinggul() { return pinggul; }
    public void setPinggul(Double pinggul) { this.pinggul = pinggul; }

    public Double getPanjangBaju() { return panjangBaju; }
    public void setPanjangBaju(Double panjangBaju) { this.panjangBaju = panjangBaju; }

    public Double getPanjangLengan() { return panjangLengan; }
    public void setPanjangLengan(Double panjangLengan) { this.panjangLengan = panjangLengan; }

    public Double getPanjangSeluar() { return panjangSeluar; }
    public void setPanjangSeluar(Double panjangSeluar) { this.panjangSeluar = panjangSeluar; }

    public Double getUkuranLeher() { return ukuranLeher; }
    public void setUkuranLeher(Double ukuranLeher) { this.ukuranLeher = ukuranLeher; }

    public Double getUkuranLenganAtas() { return ukuranLenganAtas; }
    public void setUkuranLenganAtas(Double ukuranLenganAtas) { this.ukuranLenganAtas = ukuranLenganAtas; }

    public String getCatatanUkuran() { return catatanUkuran; }
    public void setCatatanUkuran(String catatanUkuran) { this.catatanUkuran = catatanUkuran; }

    public String getDikemasKiniOleh() { return dikemasKiniOleh; }
    public void setDikemasKiniOleh(String dikemasKiniOleh) { this.dikemasKiniOleh = dikemasKiniOleh; }

    public String getNamaPengemaSkini() { return namaPengemaSkini; }
    public void setNamaPengemaSkini(String namaPengemaSkini) { this.namaPengemaSkini = namaPengemaSkini; }

    public Timestamp getTarikhKemaskini() { return tarikhKemaskini; }
    public void setTarikhKemaskini(Timestamp tarikhKemaskini) { this.tarikhKemaskini = tarikhKemaskini; }

    public Timestamp getTarikhCipta() { return tarikhCipta; }
    public void setTarikhCipta(Timestamp tarikhCipta) { this.tarikhCipta = tarikhCipta; }

    /**
     * Semak sama ada rekod ini kosong (semua ukuran null).
     */
    public boolean adaData() {
        return bahu != null || dada != null || pinggang != null || pinggul != null
            || panjangBaju != null || panjangLengan != null || panjangSeluar != null
            || ukuranLeher != null || ukuranLenganAtas != null;
    }
}
