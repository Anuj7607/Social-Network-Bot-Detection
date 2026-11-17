name,description,query,id,parentId,isFolder,isProtected
Drafts,,,0,,true,true
Untitled Query,,"MATCH (n) 
RETURN labels(n) AS NodeType, count(n) AS TotalCount;",1,0,false,false
Untitled Query 1,,"MATCH (u:User) 
RETURN u.isBot AS IsBotAccount, count(u) AS TotalUsers;",2,0,false,false
Find closed 3-way bot follow rings,,"// Find closed 3-way bot follow rings
MATCH path = (u1:User {isBot: true})-[:FOLLOWS {type: 'BOT_RING'}]->(u2:User)-[:FOLLOWS {type: 'BOT_RING'}]->(u3:User)-[:FOLLOWS {type: 'BOT_RING'}]->(u1)
RETURN u1.userId AS Bot1, u2.userId AS Bot2, u3.userId AS Bot3, length(path) AS PathLength
LIMIT 10;",3,0,false,false
Identify posts heavily amplified by bot accounts,,"// Identify posts heavily amplified by bot accounts
MATCH (p:Post)<-[:LIKED]-(u:User)
WITH p, count(u) AS totalLikes, sum(CASE WHEN u.isBot = true THEN 1 ELSE 0 END) AS botLikes
WHERE botLikes > 0
RETURN p.postId AS PostID, totalLikes, botLikes, toInteger((toFloat(botLikes) / totalLikes) * 100) AS BotAmplificationPercentage
ORDER BY botLikes DESC
LIMIT 5;",4,0,false,false
Top users by out-degree (who they follow) to highlight automated mass-following behavior,,"// Top users by out-degree (who they follow) to highlight automated mass-following behavior
MATCH (u:User)-[r:FOLLOWS]->()
RETURN u.userId AS UserID, u.isBot AS IsBot, count(r) AS OutDegree
ORDER BY OutDegree DESC
LIMIT 10;",5,0,false,false
Untitled Query 2,,"MATCH path = (u1:User {isBot: true})-[:FOLLOWS]->(u2:User)
RETURN path
LIMIT 30;",6,0,false,false
Untitled Query 3,,"MATCH path = (u:User {isBot: true})-[:POSTED]->(p:Post)<-[:LIKED]-(u2:User)
RETURN path
LIMIT 25;",7,0,false,false