package com.sewvana.model;

import java.io.Serializable;

public class Pengguna implements Serializable {
    private int id;
    private String nama;
    private String email;
    private String peranan;
    private String telefon;

    public Pengguna() {}

    public Pengguna(int id, String nama, String email, String peranan, String telefon) {
        this.id = id;
        this.nama = nama;
        this.email = email;
        this.peranan = peranan;
        this.telefon = telefon;
    }

    // Getter dan Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNama() { return nama; }
    public void setNama(String nama) { this.nama = nama; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPeranan() { return peranan; }
    public void setPeranan(String peranan) { this.peranan = peranan; }
    public String getTelefon() { return telefon; }
    public void setTelefon(String telefon) { this.telefon = telefon; }
}