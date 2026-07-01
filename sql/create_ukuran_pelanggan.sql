-- ============================================================
-- Sewvana: Jadual Ukuran Pelanggan (Customer Measurements)
-- Jalankan skrip ini dalam MySQL / phpMyAdmin anda
-- ============================================================

CREATE TABLE IF NOT EXISTS `ukuran_pelanggan` (
    `id`                  INT          NOT NULL AUTO_INCREMENT,
    `pelanggan_id`        INT          NOT NULL,

    -- Ukuran Badan Utama (dalam CM)
    `bahu`                DECIMAL(5,1) NULL COMMENT 'Lebar bahu (cm)',
    `dada`                DECIMAL(5,1) NULL COMMENT 'Lilitan dada (cm)',
    `pinggang`            DECIMAL(5,1) NULL COMMENT 'Lilitan pinggang (cm)',
    `pinggul`             DECIMAL(5,1) NULL COMMENT 'Lilitan pinggul (cm)',

    -- Panjang / Bahagian Bawah
    `panjang_baju`        DECIMAL(5,1) NULL COMMENT 'Panjang keseluruhan baju (cm)',
    `panjang_lengan`      DECIMAL(5,1) NULL COMMENT 'Panjang lengan baju (cm)',
    `panjang_seluar`      DECIMAL(5,1) NULL COMMENT 'Panjang seluar / kain (cm)',

    -- Ukuran Tambahan
    `ukuran_leher`        DECIMAL(5,1) NULL COMMENT 'Lilitan leher (cm)',
    `ukuran_lengan_atas`  DECIMAL(5,1) NULL COMMENT 'Lilitan lengan atas / bicep (cm)',

    -- Catatan bebas
    `catatan_ukuran`      TEXT         NULL COMMENT 'Catatan khas dari pelanggan atau penjahit',

    -- Metadata kemaskini
    `dikemas_kini_oleh`   ENUM('PELANGGAN','PENJAHIT') NOT NULL DEFAULT 'PELANGGAN',
    `nama_pengemas_kini`  VARCHAR(150) NULL COMMENT 'Nama orang yang terakhir edit',
    `tarikh_kemaskini`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `tarikh_cipta`        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_pelanggan_ukuran` (`pelanggan_id`),
    CONSTRAINT `fk_ukuran_pelanggan`
        FOREIGN KEY (`pelanggan_id`)
        REFERENCES `pengguna` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Simpan ukuran badan pelanggan untuk tempahan jahitan';
