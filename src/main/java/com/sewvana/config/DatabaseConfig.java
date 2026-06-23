package com.sewvana.config;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DatabaseConfig {
    private static DataSource dataSource = null;

    static {
        try {
            InitialContext context = new InitialContext();
            // JNDI lookup mengikut standard Tomcat
            dataSource = (DataSource) context.lookup("java:comp/env/jdbc/SewvanaDB");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource tidak diisytiharkan dengan betul.");
        }
        return dataSource.getConnection();
    }
}