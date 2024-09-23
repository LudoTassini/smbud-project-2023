// Query 1
db.steam_collection.aggregate([
    {"$match": {"$and": [{"metacritic_score": {"$gte": 90}}, {"price": {"$gt": 0}}]}},
    {"$sort": {"price": 1}}, {"$limit": 1}
])

// Query 2
db.steam_collection.aggregate([
    {"$match": {"$and": [{"price": 0}, {"categories": "Single-player"}]}}, 
    {"$unwind": "$genres"}, 
    {"$group": {"_id": "$genres", "count": {"$sum": 1}}}
])

// Query 3
db.steam_collection.aggregate([
    {"$unwind": "$publishers"},
    {"$group": {"_id": "$publishers", "totalRacingTags": {"$sum": "$tags.Racing"}}},
    {"$match": {"totalRacingTags": {"$gt": 0}}}
])

// Query 4
db.steam_collection.aggregate([
    {"$unwind": "$genres"},
    {"$group": {
        "_id": "$genres", 
        "averagePlaytime": {"$avg": "$average_playtime_forever"},
        "averagePlaytime2Weeks": {"$avg": "$average_playtime_2weeks"}
        }
    },
    {"$project": {
        "_id": 0, 
        "genre": "$_id", 
        "averagePlaytime": 1, 
        "averagePlaytime2Weeks": 1
        }
    },
    {"$sort": {"averagePlaytime": -1, "averagePlaytime2Weeks": -1}}
])

// Query 5
db.steam_collection.aggregate([
    {"$match": {"price": { "$ne": 0 }}},
    {"$group": {
        "_id": {"year": {"$year": "$release_date"}},
        "averagePrice": {"$avg": "$price"}, 
        "count": {"$sum": 1}
        }
    },
    {"$project": {
        "_id": 0, 
        "year": "$_id.year", 
        "averagePrice": 1, 
        "gameCount": "$count"
        }
    },
    {"$sort": {"year": 1}}
])

// Query 6
db.steam_collection.aggregate([
    {"$match": {"price": { "$ne": 0 }}},
    {"$unwind": "$publishers"},
    {"$group": {"_id": "$publishers", "gameCount": { "$sum": 1 }, "avgPrice": { "$avg": "$price"}}},
    {"$project": {"_id": 0, "publisher": "$_id", "gameCount": 1, "avgPrice": 1}},
    {"$sort": {"gameCount": -1}}
])

// Query 7
db.steam_collection.aggregate([
    {"$match": {"genres": {"$in": ["Free to Play"]}}}, 
    {"$match": {"required_age": {"$gte": 18}}},
    {"$match": {"windows": true}}, 
    {"$match": {"linux": true}}, 
    {"$match": {"mac": true}},
    {"$project": {"_id": 0, "name": 1}}
])

// Query 8
db.steam_collection.aggregate([
    {"$match": {"supported_languages": {"$in": ["Italian"]}}}, 
    {"$match": {"full_audio_languages": {"$in": ["Italian"]}}}, 
    {"$match": {"genres": {"$in": ["Strategy"]}}}, 
    {"$project": {"_id": 0, "name": 1}}
])

// Query 9
db.steam_collection.countDocuments(
    {"developers": {"$in": ["FromSoftware Inc."]}}
)

// Query 10
db.steam_collection.aggregate([
    {"$match": {"publishers": {"$in": ["Amazon Games"]}}},
    {"$sort": {"price": -1}}, {"$limit": 1}, 
    {"$project": {"_id": 0, "name": 1, "price": 1}}
])