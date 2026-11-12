package model;

import java.io.Serializable;

public class ScreeningRoom6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private int capacity;
    private String screenType;
    private String description;

    public ScreeningRoom6() {}

    public ScreeningRoom6(int id, String name, int capacity, String screenType, String description) {
        this.id = id;
        this.name = name;
        this.capacity = capacity;
        this.screenType = screenType;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public String getScreenType() { return screenType; }
    public void setScreenType(String screenType) { this.screenType = screenType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}

