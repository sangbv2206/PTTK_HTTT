package model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Invoice6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private long totalAmount;
    private long discountAmount;
    private long finalAmount;
    private Timestamp createdAt;
    private Customer customer;
    private SalesStaff staff;
    private PaymentMethod6 paymentMethod;
    private List<Ticket6> tickets;

    public Invoice6() {
        this.tickets = new ArrayList<>();
    }

    public Invoice6(int id, long totalAmount, long discountAmount, long finalAmount, 
                    Timestamp createdAt, Customer customer, SalesStaff staff, 
                    PaymentMethod6 paymentMethod, List<Ticket6> tickets) {
        this.id = id;
        this.totalAmount = totalAmount;
        this.discountAmount = discountAmount;
        this.finalAmount = finalAmount;
        this.createdAt = createdAt;
        this.customer = customer;
        this.staff = staff;
        this.paymentMethod = paymentMethod;
        this.tickets = tickets != null ? tickets : new ArrayList<>();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public long getTotalAmountLong() { return totalAmount; }
    public double getTotalAmount() { return (double) totalAmount; }
    public void setTotalAmount(long totalAmount) { this.totalAmount = totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = Math.round(totalAmount); }

    public long getDiscountAmountLong() { return discountAmount; }
    public double getDiscountAmount() { return (double) discountAmount; }
    public void setDiscountAmount(long discountAmount) { this.discountAmount = discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = Math.round(discountAmount); }

    public long getFinalAmountLong() { return finalAmount; }
    public double getFinalAmount() { return (double) finalAmount; }
    public void setFinalAmount(long finalAmount) { this.finalAmount = finalAmount; }
    public void setFinalAmount(double finalAmount) { this.finalAmount = Math.round(finalAmount); }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }

    public SalesStaff getStaff() { return staff; }
    public void setStaff(SalesStaff staff) { this.staff = staff; }

    public PaymentMethod6 getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod6 paymentMethod) { this.paymentMethod = paymentMethod; }

    public List<Ticket6> getTickets() { return tickets; }
    public void setTickets(List<Ticket6> tickets) { this.tickets = tickets; }
}

