package model;

import java.sql.Date;

public class Customer extends User {
    private static final long serialVersionUID = 1L;

    private String cus_id;
    private int loyaltyPoints;
    private MembershipCard6 card;

    public Customer() {
        super();
        this.role = "CUSTOMER";
    }

    public Customer(String fullName, Date dateOfBirth, String address, 
                    String phoneNumber, String email, String username, String password) {
        super(fullName, dateOfBirth, address, phoneNumber, email, username, password, "CUSTOMER");
        this.loyaltyPoints = 0;
    }

    public Customer(int id, String fullName, Date dateOfBirth, String address, 
                    String phoneNumber, String email, String username, String password,
                    String cus_id, int loyaltyPoints, MembershipCard6 card) {
        super(id, fullName, dateOfBirth, address, phoneNumber, email, username, password, "CUSTOMER");
        this.cus_id = cus_id;
        this.loyaltyPoints = loyaltyPoints;
        this.card = card;
    }

    public String getCus_id() {
        return cus_id;
    }

    public void setCus_id(String cus_id) {
        this.cus_id = cus_id;
    }

    public int getLoyaltyPoints() {
        return loyaltyPoints;
    }

    public void setLoyaltyPoints(int loyaltyPoints) {
        this.loyaltyPoints = loyaltyPoints;
    }

    public MembershipCard6 getCard() {
        return card;
    }

    public void setCard(MembershipCard6 card) {
        this.card = card;
    }
}

