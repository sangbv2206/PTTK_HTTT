package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Showtime6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Timestamp startTime;
    private Timestamp endTime;
    private String format;
    private Movie6 movie;
    private ScreeningRoom6 room;

    public Showtime6() {}

    public Showtime6(int id, Timestamp startTime, Timestamp endTime, String format, Movie6 movie, ScreeningRoom6 room) {
        this.id = id;
        this.startTime = startTime;
        this.endTime = endTime;
        this.format = format;
        this.movie = movie;
        this.room = room;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }

    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }

    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }

    public Movie6 getMovie() { return movie; }
    public void setMovie(Movie6 movie) { this.movie = movie; }

    public ScreeningRoom6 getRoom() { return room; }
    public void setRoom(ScreeningRoom6 room) { this.room = room; }
}

