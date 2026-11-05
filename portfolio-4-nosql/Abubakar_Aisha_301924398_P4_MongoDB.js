// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("meter_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("meter_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "reading_recorded",
                    "low_voltage_alert"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "energy_reading"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("meter_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "reading_recorded",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "energy_reading",
            "key": {
                "id": 5
            },
            "snapshot": {
                "id": 5,
                "meter_id": 3,
                "recorded_at": "2024-07-01T10:00:00Z",
                "kwh_total": 125.5,
                "voltage": 230.1
            }
        },
        "embedded": {},
        "references": {
            "meter": [
                {
                    "key": {
                        "id": 3
                    },
                    "via": [
                        "energy_reading.meter_id → meter"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "low_voltage_alert",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "energy_reading",
            "key": {
                "id": 5
            },
            "snapshot": {
                "id": 5,
                "meter_id": 3,
                "recorded_at": "2024-07-01T10:00:00Z",
                "kwh_total": 125.5,
                "voltage": 230.1
            }
        },
        "embedded": {},
        "references": {
            "meter": [
                {
                    "key": {
                        "id": 3
                    },
                    "via": [
                        "energy_reading.meter_id → meter"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "energy_reading",
                    "key": {
                        "id": 5
                    },
                    "field": "voltage",
                    "value": 230.1
                }
            ],
            "examples": {
                "signal_strength": "illustrative signal_strength",
                "alert_code": "illustrative alert_code"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "reading_recorded",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "energy_reading",
            "key": {
                "id": 6
            },
            "snapshot": {
                "id": 6,
                "meter_id": 4,
                "recorded_at": "2024-07-01T10:05:00+00:00",
                "kwh_total": 82.75,
                "voltage": null
            }
        },
        "embedded": {},
        "references": {
            "meter": [
                {
                    "key": {
                        "id": 4
                    },
                    "via": [
                        "energy_reading.meter_id → meter"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "low_voltage_alert",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "energy_reading",
            "key": {
                "id": 6
            },
            "snapshot": {
                "id": 6,
                "meter_id": 4,
                "recorded_at": "2024-07-01T10:05:00+00:00",
                "kwh_total": 82.75,
                "voltage": null
            }
        },
        "embedded": {},
        "references": {
            "meter": [
                {
                    "key": {
                        "id": 4
                    },
                    "via": [
                        "energy_reading.meter_id → meter"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "energy_reading",
                    "key": {
                        "id": 6
                    },
                    "field": "voltage",
                    "value": null
                }
            ],
            "examples": {
                "signal_strength": "illustrative signal_strength",
                "alert_code": "illustrative alert_code"
            }
        }
    }
]));
  await db.getCollection("meter_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("meter_events").find({"eventType":"reading_recorded"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("meter_events").find({"source.key.id":5}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("meter_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("meter_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("meter_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "reading_recorded",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "energy_reading",
        "key": {
            "id": 5
        },
        "snapshot": {
            "id": 5,
            "meter_id": 3,
            "recorded_at": "2024-07-01T10:00:00Z",
            "kwh_total": 125.5,
            "voltage": 230.1
        }
    },
    "embedded": {},
    "references": {
        "meter": [
            {
                "key": {
                    "id": 3
                },
                "via": [
                    "energy_reading.meter_id → meter"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("meter_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "reading_recorded",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "energy_reading",
        "key": {
            "id": 5
        },
        "snapshot": {
            "id": 5,
            "meter_id": 3,
            "recorded_at": "2024-07-01T10:00:00Z",
            "kwh_total": 125.5,
            "voltage": 230.1
        }
    },
    "embedded": {},
    "references": {
        "meter": [
            {
                "key": {
                    "id": 3
                },
                "via": [
                    "energy_reading.meter_id → meter"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("meter_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
