# Social Network Analysis & Bot Ring Detection using Neo4j

A Big Data Analytics project designed to detect fake accounts, coordinated inauthentic behavior, structural bot rings, and co-amplification hubs using **Neo4j AuraDB**, **Graph Theory**, and **Python**.

---

## 🎯 Project Overview
Modern social media platforms face widespread manipulation from coordinated bot networks that artificially inflate engagement metrics. Unlike traditional relational databases (SQL) that suffer from severe performance degradation during multi-hop `JOIN` operations, this project models social interactions as a **Property Graph** in **Neo4j**, enabling near-instantaneous traversal and pattern detection through index-free adjacency.

## 🛠️ Tech Stack
* **Graph Database:** Neo4j AuraDB (Cloud)
* **Query Language:** Cypher
* **Data Engineering & Ingestion:** Python, Pandas, Faker, Official Neo4j Python Driver
* **Environment:** Google Colab

---

## 🗂️ Repository Structure
```text
Bot-Detection-Project/
├── data/               # Synthetic datasets (users.csv, follows.csv, posts.csv, likes.csv)
├── notebooks/          # Google Colab notebook for synthetic data generation & AuraDB ingestion
├── queries/            # Master Cypher query suite for bot ring & behavioral detection
└── README.md           # Project documentation
```

---

## 🕸️ Graph Data Model
* **Nodes:**
  * `:User` (`userId`, `name`, `isBot`, `createdAt`)
  * `:Post` (`postId`, `timestamp`)
* **Relationships:**
  * `(:User)-[:FOLLOWS {type}]->(:User)`
  * `(:User)-[:POSTED]->(:Post)`
  * `(:User)-[:LIKED]->(:Post)`

---

## 🔍 Detection Methodology & Key Queries

### 1. Structural Detection (Reciprocal Follow Rings)
Uncovers closed-loop 3-way follow rings where bots exclusively follow one another in a circle to fake popularity:
```cypher
MATCH path = (u1:User {isBot: true})-[:FOLLOWS {type: 'BOT_RING'}]->(u2:User)-[:FOLLOWS {type: 'BOT_RING'}]->(u3:User)-[:FOLLOWS {type: 'BOT_RING'}]->(u1)
RETURN u1.userId AS Bot1, u2.userId AS Bot2, u3.userId AS Bot3, length(path) AS PathLength
LIMIT 10;
```

### 2. Behavioral Detection (Co-Amplification Hubs)
Identifies posts with an unusually high percentage of synchronized likes originating from bot accounts:
```cypher
MATCH (p:Post)<-[:LIKED]-(u:User)
WITH p, count(u) AS totalLikes, sum(CASE WHEN u.isBot = true THEN 1 ELSE 0 END) AS botLikes
WHERE botLikes > 0
RETURN p.postId AS PostID, totalLikes, botLikes, toInteger((toFloat(botLikes) / totalLikes) * 100) AS BotAmplificationPercentage
ORDER BY botLikes DESC
LIMIT 5;
```

### 3. Centrality & Social Footprint Analysis
Evaluates out-degree metrics to highlight automated mass-following behavior:
```cypher
MATCH (u:User)-[r:FOLLOWS]->()
RETURN u.userId AS UserID, u.isBot AS IsBot, count(r) AS OutDegree
ORDER BY OutDegree DESC
LIMIT 10;
```

---

## 🚀 How to Run
1. **Generate & Ingest Data:** Open the `.ipynb` notebook in Google Colab, add your Neo4j AuraDB URI and credentials, and run all cells to generate the synthetic CSVs and populate the graph.
2. **Analyze & Visualize:** Open the Neo4j Query Console and execute the queries from `queries/bot_detection_queries.cypher`. Switch to the **Graph** view tab when running path queries to inspect the visual bot clusters.