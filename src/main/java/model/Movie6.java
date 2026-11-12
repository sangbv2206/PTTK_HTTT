package model;

import java.io.Serializable;
import java.sql.Date;

public class Movie6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String title;
    private String genre;
    private int duration;
    private String director;
    private String cast;
    private Date releaseDate;
    private String description;
    private String posterUrl;

    public Movie6() {}

    public Movie6(int id, String title, String genre, int duration, String director, 
                  String cast, Date releaseDate, String description, String posterUrl) {
        this.id = id;
        this.title = title;
        this.genre = genre;
        this.duration = duration;
        this.director = director;
        this.cast = cast;
        this.releaseDate = releaseDate;
        this.description = description;
        this.posterUrl = posterUrl;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public String getDirector() { return director; }
    public void setDirector(String director) { this.director = director; }

    public String getCast() { return cast; }
    public void setCast(String cast) { this.cast = cast; }

    public Date getReleaseDate() { return releaseDate; }
    public void setReleaseDate(Date releaseDate) { this.releaseDate = releaseDate; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPosterUrl() { return posterUrl; }
    public void setPosterUrl(String posterUrl) { this.posterUrl = posterUrl; }

    public String getPoster() { return posterUrl; }
    public void setPoster(String poster) { this.posterUrl = poster; }
}

