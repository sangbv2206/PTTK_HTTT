package model;

import java.io.Serializable;

public class Seat6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String seatNumber;
    private String seatType; // STANDARD, VIP, COUPLE
    private String status;
    private ScreeningRoom6 room;

    public Seat6() {}

    public Seat6(int id, String seatNumber, String seatType, String status, ScreeningRoom6 room) {
        this.id = id;
        this.seatNumber = seatNumber;
        this.seatType = seatType;
        this.status = status;
        this.room = room;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSeatNumber() { return seatNumber; }
    public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }

    public String getSeatType() { return seatType; }
    public void setSeatType(String seatType) { this.seatType = seatType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public ScreeningRoom6 getRoom() { return room; }
    public void setRoom(ScreeningRoom6 room) { this.room = room; }
}

