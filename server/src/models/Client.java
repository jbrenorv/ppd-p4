package models;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;

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

    public JsonObject toJsonObject() {
        JsonObjectBuilder jsonObjectBuilder = Json.createObjectBuilder();

        jsonObjectBuilder.add("id", this.id);
        jsonObjectBuilder.add("name", this.name);

        return jsonObjectBuilder.build();
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof Client)) return false;
        return this.id.equals(((Client) obj).id);
    }

    @Override
    public int hashCode() {
        return this.id.hashCode();
    }
}
