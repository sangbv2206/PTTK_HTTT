package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Ticket6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private double salePrice;
    private Timestamp purchaseTime;
    private String qrCode;
    private ShowtimeSeat6 showtimeSeat;
    private int invoiceId;

    public Ticket6() {}

    public Ticket6(int id, double salePrice, Timestamp purchaseTime, String qrCode, ShowtimeSeat6 showtimeSeat, int invoiceId) {
        this.id = id;
        this.salePrice = salePrice;
        this.purchaseTime = purchaseTime;
        this.qrCode = qrCode;
        this.showtimeSeat = showtimeSeat;
        this.invoiceId = invoiceId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public double getSalePrice() { return salePrice; }
    public void setSalePrice(double salePrice) { this.salePrice = salePrice; }

    public Timestamp getPurchaseTime() { return purchaseTime; }
    public void setPurchaseTime(Timestamp purchaseTime) { this.purchaseTime = purchaseTime; }

    public String getQrCode() { return qrCode; }
    public void setQrCode(String qrCode) { this.qrCode = qrCode; }

    public ShowtimeSeat6 getShowtimeSeat() { return showtimeSeat; }
    public void setShowtimeSeat(ShowtimeSeat6 showtimeSeat) { this.showtimeSeat = showtimeSeat; }

    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }
}

