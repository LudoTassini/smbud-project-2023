// Query 1
MATCH (other:User)-[r:HAS_INFLUENCE_OVER]->(u:User)
WITH u, other, COLLECT(r) AS relationships
WHERE ALL(rel IN relationships WHERE rel.influence_value <= 0.1)
WITH u, COUNT(other) AS num_incoming_relationships
ORDER BY num_incoming_relationships ASC LIMIT 10
RETURN u

// Query 2
MATCH (u1:User)-[:HAS_INFLUENCE_OVER]-> (u2:User)-[:HAS_INFLUENCE_OVER]->(u1:User) 
RETURN u1, u2

// Query 3
MATCH (u1:User) WITH MAX(u1.engagement_rate) AS max_engagement_rate 
MATCH (u2:User {engagement_rate: max_engagement_rate}) 
RETURN AVG(u2.num_posts)

// Query 4
MATCH (u:User)
WITH u, u.engagement_rate * u.num_followers AS total_interactions
ORDER BY total_interactions DESC
RETURN u.user_id, total_interactions
LIMIT 5

// Query 5
MATCH (u:User)
WHERE u.followers_growth_per_month > 0.5
WITH u, u.engagement_rate * u.num_followers AS total_interactions
RETURN AVG(u.num_posts) AS avg_posts, AVG(total_interactions) AS avg_total_intearctions

// Query 6
MATCH (u1:User)-[r:HAS_INFLUENCE_OVER]->(u2:User)
WHERE u1.num_followers > 50000 AND u2.num_followers > 50000
WITH u1, COUNT(u2) AS influencedUsersCount
RETURN u1.user_id, influencedUsersCount
ORDER BY influencedUsersCount DESC LIMIT 10

// Query 7
MATCH (u1:User)-[r:HAS_INFLUENCE_OVER]->(u2:User)
WITH u1, SUM(r.influence_value) AS totalInfluence
ORDER BY totalInfluence DESC
LIMIT 1
RETURN u1.user_id, u1.num_followers, u1.outsiders_percentage, u1.num_posts, totalInfluence

// Query 8
MATCH (u1:User)-[:HAS_INFLUENCE_OVER]->(u2:User)
WITH u1, COUNT(u2) AS num_relationships
ORDER BY num_relationships DESC
LIMIT 1
RETURN u1.user_id, u1.num_followers, u1.outsiders_percentage, u1.num_posts, num_relationships

// Query 9
MATCH (u1:User)
WITH MIN(u1.followers_growth_per_month) AS min_growth
MATCH (u2:User {followers_growth_per_month: min_growth})-[r:HAS_INFLUENCE_OVER]->(u3:User)
WITH u2, SUM(r.influence_value) AS totalInfluence ORDER BY totalInfluence
RETURN u2.user_id, totalInfluence

// Query 10
MATCH (u:User)
WITH u,
CASE
WHEN u.num_followers > u.num_following THEN 'more_followers'
WHEN u.num_followers < u.num_following THEN 'more_following'
ELSE 'equal_followers_following'
END AS relationshipType
RETURN relationshipType, COUNT(u) AS numberOfUsers