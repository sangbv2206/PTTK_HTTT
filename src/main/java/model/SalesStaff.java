package model;

import java.sql.Date;

public class SalesStaff extends Employee {
    private static final long serialVersionUID = 1L;

    public SalesStaff() {
        super();
        this.position = "Nhân viên bán vé";
    }

    public SalesStaff(int id, String fullName, Date dateOfBirth, String address, 
                      String phoneNumber, String email, String username, String password,
                      String employeeCode) {
        super(id, fullName, dateOfBirth, address, phoneNumber, email, username, password, employeeCode, "Nhân viên bán vé");
    }
}

