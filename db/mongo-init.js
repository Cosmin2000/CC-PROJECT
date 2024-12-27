db = db.getSiblingDB('db');

db.createCollection('Tari');
db.createCollection('Orase');
db.createCollection('Temperaturi');

db.Tari.createIndex({ "id": 1 }, { unique: true });
db.Tari.createIndex({ "nume_tara": 1 }, { unique: true });
db.Orase.createIndex({ "id": 1, "nume_oras": 1 }, { unique: true });
db.Orase.createIndex({ "id_tara": 1, "nume_oras": 1 }, { unique: true });
db.Temperaturi.createIndex({ "id": 1, "timestamp": 1 }, { unique: true });
db.Temperaturi.createIndex({ "id_oras": 1, "timestamp": 1 }, { unique: true });