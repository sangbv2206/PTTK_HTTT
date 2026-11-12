package model;

import java.sql.Date;

public class Employee extends User {
    private static final long serialVersionUID = 1L;

    protected String employeeCode;
    protected String position;

    public Employee() {
        super();
        this.role = "STAFF";
    }

    public Employee(int id, String fullName, Date dateOfBirth, String address, 
                    String phoneNumber, String email, String username, String password,
                    String employeeCode, String position) {
        super(id, fullName, dateOfBirth, address, phoneNumber, email, username, password, "STAFF");
        this.employeeCode = employeeCode;
        this.position = position;
    }

    public String getEmployeeCode() {
        return employeeCode;
    }

    public void setEmployeeCode(String employeeCode) {
        this.employeeCode = employeeCode;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}

