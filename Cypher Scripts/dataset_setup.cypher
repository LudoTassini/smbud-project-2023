CREATE CONSTRAINT FOR (u:User) REQUIRE u.user_id IS UNIQUE;

LOAD CSV WITH HEADERS FROM "file:///InstagramUserStats.csv" AS row
WITH row WHERE row.id IS NOT NULL
MERGE (u:User {user_id: toInteger(row.id)})
ON CREATE SET u.num_posts = toInteger(row.pos),
u.num_followers = toInteger(row.flr),
u.num_following = toInteger(row.flg),
u.engagement_grade = toFloat(row.eg),
u.engagement_rate = toFloat(row.er),
u.followers_growth_per_month = toFloat(row.fg),
u.outsiders_percentage = toFloat(row.op)
ON MATCH SET u.count = coalesce(u.count, 0) + 1;

LOAD CSV WITH HEADERS FROM 'file:///Network.csv' AS row
MATCH (u1:User {user_id: toInteger(row.Source)})
MATCH (u2:User {user_id: toInteger(row.Target)})
WHERE u1.user_id <= 20000
CREATE (u1)−[:HAS_INFLUENCE_OVER {influence_value:
toFloat(row.Weight)}]−>(u2);

LOAD CSV WITH HEADERS FROM 'file:///Network.csv' AS row
MATCH (u1:User {user_id: toInteger(row.Source)})
MATCH (u2:User {user_id: toInteger(row.Target)})
WHERE 20000 < u1.user_id <= 40000
CREATE (u1)−[:HAS_INFLUENCE_OVER {influence_value:
toFloat(row.Weight)}]−>(u2);

LOAD CSV WITH HEADERS FROM 'file:///Network.csv' AS row
MATCH (u1:User {user_id: toInteger(row.Source)})
MATCH (u2:User {user_id: toInteger(row.Target)})
WHERE 40000 < u1.user_id
CREATE (u1)−[:HAS_INFLUENCE_OVER {influence_value:
toFloat(row.Weight)}]−>(u2);