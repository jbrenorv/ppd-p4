package models;

import javax.json.JsonObject;

public class Client {
    private final String id;
    private final String name;

    private Client(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public static Client createClientFromJsonObject(JsonObject jsonObject) {
        return new Client(jsonObject.getString("id"), jsonObject.getString("name"));
    }

    public String getName() {
        return this.name;
    }

    public String getQueue() {
        return this.id;
    }
}
