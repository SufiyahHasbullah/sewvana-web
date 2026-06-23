package com.sewvana.model;

import java.util.Date;

public class Tempahan {
    private int id;
    private String kodTempahan;
    private String namaPelanggan;
    private int pelangganId;
    private int penjahitId;
    private Date tarikhSlot;
    private String kategoriPakaian;
    private String catatan;
    private String statusTempahan;

    private String namaPenjahit;
    private String kaedahUkuran;
    private String masaSesiUkur;

    public Tempahan() {}

    // Getters dan Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getKodTempahan() { return kodTempahan; }
    public void setKodTempahan(String kodTempahan) { this.kodTempahan = kodTempahan; }

    public String getNamaPelanggan() { return namaPelanggan; }
    public void setNamaPelanggan(String namaPelanggan) { this.namaPelanggan = namaPelanggan; }

    public String getNamaPenjahit() { return namaPenjahit; }
    public void setNamaPenjahit(String namaPenjahit) { this.namaPenjahit = namaPenjahit; }

    public int getPelangganId() { return pelangganId; }
    public void setPelangganId(int pelangganId) { this.pelangganId = pelangganId; }

    public int getPenjahitId() { return penjahitId; }
    public void setPenjahitId(int penjahitId) { this.penjahitId = penjahitId; }

    public Date getTarikhSlot() { return tarikhSlot; }
    public void setTarikhSlot(Date tarikhSlot) { this.tarikhSlot = tarikhSlot; }

    public String getKategoriPakaian() { return kategoriPakaian; }
    public void setKategoriPakaian(String kategoriPakaian) { this.kategoriPakaian = kategoriPakaian; }

    public String getCatatan() { return catatan; }
    public void setCatatan(String catatan) { this.catatan = catatan; }

    public String getStatusTempahan() { return statusTempahan; }
    public void setStatusTempahan(String statusTempahan) { this.statusTempahan = statusTempahan; }

    public String getKaedahUkuran() { return kaedahUkuran; }
    public void setKaedahUkuran(String kaedahUkuran) { this.kaedahUkuran = kaedahUkuran; }

    public String getMasaSesiUkur() { return masaSesiUkur; }
    public void setMasaSesiUkur(String masaSesiUkur) { this.masaSesiUkur = masaSesiUkur; }
}