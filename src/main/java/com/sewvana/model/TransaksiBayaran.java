package com.sewvana.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class TransaksiBayaran implements Serializable {
    private int id;
    private int tempahanSlotId;
    private String kodResit;
    private String jenisBayaran;
    private BigDecimal jumlahBayaran;
    private String kaedahBayaran;
    private String statusBayaran;
    private String idTransaksiGateway;
    private Timestamp tarikhBayaran;

    // Sambungan data join (Untuk paparan UI Sejarah & Resit)
    private String kodTempahan;
    private String namaPenjahit;
    private String namaPelanggan;
    private String kategoriPakaian;

    public TransaksiBayaran() {}

    // Getters dan Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getTempahanSlotId() { return tempahanSlotId; }
    public void setTempahanSlotId(int tempahanSlotId) { this.tempahanSlotId = tempahanSlotId; }
    public String getKodResit() { return kodResit; }
    public void setKodResit(String kodResit) { this.kodResit = kodResit; }
    public String getJenisBayaran() { return jenisBayaran; }
    public void setJenisBayaran(String jenisBayaran) { this.jenisBayaran = jenisBayaran; }
    public BigDecimal getJumlahBayaran() { return jumlahBayaran; }
    public void setJumlahBayaran(BigDecimal jumlahBayaran) { this.jumlahBayaran = jumlahBayaran; }
    public String getKaedahBayaran() { return kaedahBayaran; }
    public void setKaedahBayaran(String kaedahBayaran) { this.kaedahBayaran = kaedahBayaran; }
    public String getStatusBayaran() { return statusBayaran; }
    public void setStatusBayaran(String statusBayaran) { this.statusBayaran = statusBayaran; }
    public String getIdTransaksiGateway() { return idTransaksiGateway; }
    public void setIdTransaksiGateway(String idTransaksiGateway) { this.idTransaksiGateway = idTransaksiGateway; }
    public Timestamp getTarikhBayaran() { return tarikhBayaran; }
    public void setTarikhBayaran(Timestamp tarikhBayaran) { this.tarikhBayaran = tarikhBayaran; }
    public String getKodTempahan() { return kodTempahan; }
    public void setKodTempahan(String kodTempahan) { this.kodTempahan = kodTempahan; }
    public String getNamaPenjahit() { return namaPenjahit; }
    public void setNamaPenjahit(String namaPenjahit) { this.namaPenjahit = namaPenjahit; }
    public String getNamaPelanggan() { return namaPelanggan; }
    public void setNamaPelanggan(String namaPelanggan) { this.namaPelanggan = namaPelanggan; }
    public String getKategoriPakaian() { return kategoriPakaian; }
    public void setKategoriPakaian(String kategoriPakaian) { this.kategoriPakaian = kategoriPakaian; }
}