# Repo-Track-Pipeline
![image](https://user-images.githubusercontent.com/63877/231985040-20ae1701-00e1-4800-b1ea-225a60dba0d2.png)

Repo-Track-Pipeline is an open-source tool that allows you to sync repository data from GitHub to TiDB Cloud, a MySQL-compatible cloud database. With Repo-Track-Pipeline, you can perform single repo analytics, multiple repo analytics, and similar repo analytics.

## Features

- You own your data. With repo-track-pipeline, you can synchronize your own repos or a group of interesting repos to your own database. Afterwards, you can provide an API for your own service or use BI tools to query the data. You have complete control over the data.
- Single repo analytics: Analyze data from a single repository.
- Multiple repo analytics: Merge data from multiple repositories into one, useful for repositories that are split into multiple small repositories.
- Similar repo analytics: Compare collections of repositories. [Bitcoin vs Auto-GPT](https://bitcoin-vs-autogpt.vercel.app/) [[Source](https://github.com/gh-viz/bitcoin-vs-autogpt)]
- Fake GitHub Star detection: The tool syncs starred user data and contributor data (including follower count, registration time, etc.), making it easy to identify repositories with fake stars.
- The capability to synchronize private repository data

## Requirements

To use repo-track-pipeline, you will need the following:

- GitHub personal access token
- Cloud database service account
- GitHub Actions

### Get GitHub personal access token

You need to create a Github access token through the url https://github.com/settings/tokens/new . Note that this token does not require additional privileges and is only used to read public repository information. If you want to synchronize information from your private repositories as well, you can check the "repo" box.

![image](https://user-images.githubusercontent.com/63877/233134043-569212b0-ea80-4a36-961c-e615741e15f6.png)

### Register a MySQL cloud service

Register TiDB Cloud at https://tidbcloud.com/signup. Of course, you can also choose other cloud databases compatible with MySQL or RDS without vendor locking, such as PlanetScale and AWS RDS.

### Setup Data Pipeline

To use this repository as a standalone data pipeline, simply fork this repo, and set the secret variables and the GitHub action will run automatically every 3 hour. This will sync the specified repo's GitHub data to TiDB Cloud.

![image](https://user-images.githubusercontent.com/63877/233130431-cfe9884a-a58e-45de-a702-98b41a370ceb.png)

Action Secrets

To use this repository, you will need to set the following action secrets on GitHub:

| Secret Name | Description |
| --- | --- |
| `ACCESS_TOKEN` | A personal access token provided by GitHub, which can be obtained from [Sign in to GitHub · GitHub](https://github.com/settings/tokens). |
| `DATABASE_URL` | The MySQL connection information in uri format for TiDB Cloud. You will need to register and create a serverless cluster on [https://tidb.cloud](https://tidb.cloud/), and the URI format should contain the necessary information for connecting to the cluster. An example of the DATABASE_URL format is: mysql2://xxx.root:password@hostxx.tidbcloud.com:4000/db_name |
| `REPO_FULL_NAME` | The full name of the repository, for example: `vercel/next.js`, you can also set multiple repository full names, such as: `vercel/next.js,vercel/vercel` or `remix-run/remix,vercel/next.js`. |


⚠️ Make sure you enable GitHub Action for this forked repo.

![image](https://user-images.githubusercontent.com/63877/233132878-b6879d1c-272b-4db5-93f6-587f4d64b72a.png)


Note: repo-track-pipeline is crash-safe. If the pipeline fails for any reason, you can manually run GitHub Actions again without worrying about data corruption. Additionally, GitHub Actions will automatically run every 3 hours.

The first time you try, you can manually trigger the GitHub Action:

![image](https://user-images.githubusercontent.com/63877/233193625-e5c4abad-33d0-440f-94d7-8532742a71a8.png)


## FAQ

### Difference with [OSSInsight](https://ossinsight.io/)

The difference between repo-track-pipeline and OSSInsight is that the data for repo-track-pipeline comes from GitHub GraphQL API. As long as you have a GitHub access token, you can use an incremental way to synchronize all public data for the project (including the repo, pull request, issue, stars, users, etc.), and all of this data is accurate. On the other hand, the data for OSSInsight comes from gharchive.org, which in turn comes from the GitHub REST API. Due to the limitations of the GitHub API and the stability issues of the gharchive service, the data is less accurate, and some dimensional data may be missing, such as user information.

## Schema

### repos

```
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| id                 | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| name               | varchar(255) | YES  |     | <null>  |                |
| owner              | varchar(255) | YES  |     | <null>  |                |
| user_id            | bigint(20)   | YES  |     | <null>  |                |
| license            | varchar(255) | YES  |     | <null>  |                |
| is_private         | tinyint(1)   | YES  |     | <null>  |                |
| disk_usage         | int(11)      | YES  |     | <null>  |                |
| language           | varchar(255) | YES  |     | <null>  |                |
| description        | text         | YES  |     | <null>  |                |
| is_fork            | tinyint(1)   | YES  |     | <null>  |                |
| parent_id          | bigint(20)   | YES  |     | <null>  |                |
| fork_count         | int(11)      | YES  |     | <null>  |                |
| stargazer_count    | int(11)      | YES  |     | <null>  |                |
| pushed_at          | datetime(6)  | YES  |     | <null>  |                |
| created_at         | datetime(6)  | NO   |     | <null>  |                |
| updated_at         | datetime(6)  | NO   |     | <null>  |                |
| is_in_organization | tinyint(1)   | YES  |     | 0       |                |
| last_issue_cursor  | varchar(255) | YES  |     | <null>  |                |
| last_star_cursor   | varchar(255) | YES  |     | <null>  |                |
| last_pr_cursor     | varchar(255) | YES  |     | <null>  |                |
| last_fork_cursor   | varchar(255) | YES  |     | <null>  |                |
+--------------------+--------------+------+-----+---------+----------------+
```

### pull_requests

```
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| id                 | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| repo_id            | bigint(20)   | YES  |     | <null>  |                |
| locked             | tinyint(1)   | YES  |     | <null>  |                |
| title              | varchar(255) | YES  |     | <null>  |                |
| closed             | tinyint(1)   | YES  |     | <null>  |                |
| closed_at          | datetime(6)  | YES  |     | <null>  |                |
| state              | varchar(255) | YES  |     | <null>  |                |
| number             | int(11)      | YES  |     | <null>  |                |
| author             | varchar(255) | YES  | MUL | <null>  |                |
| user_id            | bigint(20)   | YES  |     | <null>  |                |
| author_association | varchar(255) | YES  |     | <null>  |                |
| is_draft           | tinyint(1)   | YES  |     | <null>  |                |
| additions          | int(11)      | YES  |     | 0       |                |
| deletions          | int(11)      | YES  |     | 0       |                |
| merged_at          | datetime(6)  | YES  |     | <null>  |                |
| merged_by          | varchar(255) | YES  |     | <null>  |                |
| changed_files      | int(11)      | YES  |     | 0       |                |
| merged             | tinyint(1)   | YES  |     | <null>  |                |
| comments_count     | int(11)      | YES  |     | 0       |                |
| created_at         | datetime(6)  | NO   | MUL | <null>  |                |
| updated_at         | datetime(6)  | NO   | MUL | <null>  |                |
+--------------------+--------------+------+-----+---------+----------------+
```

### issues

```
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| id                 | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| repo_id            | bigint(20)   | YES  |     | <null>  |                |
| locked             | tinyint(1)   | YES  |     | <null>  |                |
| title              | varchar(255) | YES  |     | <null>  |                |
| closed             | tinyint(1)   | YES  |     | <null>  |                |
| closed_at          | datetime(6)  | YES  |     | <null>  |                |
| state              | varchar(255) | YES  |     | <null>  |                |
| number             | int(11)      | YES  |     | <null>  |                |
| author             | varchar(255) | YES  | MUL | <null>  |                |
| user_id            | bigint(20)   | YES  | MUL | <null>  |                |
| author_association | varchar(255) | YES  |     | <null>  |                |
| created_at         | datetime(6)  | NO   | MUL | <null>  |                |
| updated_at         | datetime(6)  | NO   | MUL | <null>  |                |
+--------------------+--------------+------+-----+---------+----------------+
```

### users

```
+------------------+--------------+------+-----+---------+----------------+
| Field            | Type         | Null | Key | Default | Extra          |
+------------------+--------------+------+-----+---------+----------------+
| id               | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| login            | varchar(255) | NO   |     | <null>  |                |
| company          | varchar(255) | YES  |     | <null>  |                |
| location         | varchar(255) | YES  |     | <null>  |                |
| twitter_username | varchar(255) | YES  |     | <null>  |                |
| followers_count  | int(11)      | YES  |     | 0       |                |
| following_count  | int(11)      | YES  |     | 0       |                |
| region           | varchar(255) | YES  |     | <null>  |                |
| created_at       | varchar(255) | NO   |     | <null>  |                |
| updated_at       | varchar(255) | NO   |     | <null>  |                |
+------------------+--------------+------+-----+---------+----------------+
```

### starred_repos

```
+------------+-------------+------+-----+---------+-------+
| Field      | Type        | Null | Key | Default | Extra |
+------------+-------------+------+-----+---------+-------+
| user_id    | bigint(20)  | NO   | MUL | <null>  |       |
| repo_id    | bigint(20)  | NO   |     | <null>  |       |
| starred_at | datetime(6) | NO   |     | <null>  |       |
+------------+-------------+------+-----+---------+-------+
```

### forks

```
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| id         | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| parent     | bigint(20)   | YES  | MUL | <null>  |                |
| author     | varchar(255) | YES  | MUL | <null>  |                |
| user_id    | bigint(20)   | YES  |     | <null>  |                |
| name       | varchar(255) | YES  |     | <null>  |                |
| created_at | datetime(6)  | NO   | MUL | <null>  |                |
| updated_at | datetime(6)  | NO   | MUL | <null>  |                |
+------------+--------------+------+-----+---------+----------------+
```


## Contributing

Contributions to Repo-Track-Pipeline are welcome! If you find a bug or have an idea for a new feature, please open an issue or submit a pull request.

## License

Repo-Track-Pipeline is licensed under the [MIT License](https://github.com/hooopo/repo-track-pipeline/blob/main/LICENSE).
