package model;

import java.io.Serializable;

public class TicketPrice6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String seatType;
    private String dayType;
    private double price;
    private Showtime6 showtime;

    public TicketPrice6() {}

    public TicketPrice6(int id, String seatType, String dayType, double price, Showtime6 showtime) {
        this.id = id;
        this.seatType = seatType;
        this.dayType = dayType;
        this.price = price;
        this.showtime = showtime;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSeatType() { return seatType; }
    public void setSeatType(String seatType) { this.seatType = seatType; }

    public String getDayType() { return dayType; }
    public void setDayType(String dayType) { this.dayType = dayType; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public Showtime6 getShowtime() { return showtime; }
    public void setShowtime(Showtime6 showtime) { this.showtime = showtime; }
}

