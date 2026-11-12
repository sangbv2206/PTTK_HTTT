package model;

import java.io.Serializable;

public class ShowtimeSeat6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String status; // AVAILABLE, HOLDING, SOLD
    private String holderSessionId;
    private Showtime6 showtime;
    private Seat6 seat;
    private double price;

    public ShowtimeSeat6() {}

    public ShowtimeSeat6(int id, String status, Showtime6 showtime, Seat6 seat, double price) {
        this.id = id;
        this.status = status;
        this.showtime = showtime;
        this.seat = seat;
        this.price = price;
    }

    public ShowtimeSeat6(int id, String status, String holderSessionId, Showtime6 showtime, Seat6 seat, double price) {
        this.id = id;
        this.status = status;
        this.holderSessionId = holderSessionId;
        this.showtime = showtime;
        this.seat = seat;
        this.price = price;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getHolderSessionId() { return holderSessionId; }
    public void setHolderSessionId(String holderSessionId) { this.holderSessionId = holderSessionId; }

    public Showtime6 getShowtime() { return showtime; }
    public void setShowtime(Showtime6 showtime) { this.showtime = showtime; }

    public Seat6 getSeat() { return seat; }
    public void setSeat(Seat6 seat) { this.seat = seat; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}

