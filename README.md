# Repo-Track-Pipeline
![image](https://user-images.githubusercontent.com/63877/231985040-20ae1701-00e1-4800-b1ea-225a60dba0d2.png)

Repo-Track-Pipeline is an open-source tool that allows you to sync repository data from GitHub to TiDB Cloud, a MySQL-compatible cloud database. With Repo-Track-Pipeline, you can perform single repo analytics, multiple repo analytics, and similar repo analytics.

## Features

- Single repo analytics: Analyze data from a single repository.
- Multiple repo analytics: Merge data from multiple repositories into one, useful for repositories that are split into multiple small repositories.
- Similar repo analytics: Compare collections of repositories. [Bitcoin vs Auto-GPT](https://bitcoin-vs-autogpt.vercel.app/) [Source](https://github.com/gh-viz/bitcoin-vs-autogpt)
- Fake GitHub Star detection: The tool syncs star user data and contributor data (including follower count, registration time, etc.), making it easy to identify repositories with fake stars.

## Requirements

To use Repo-Track-Pipeline, you will need the following:

- GitHub personal access token
- TiDB Cloud connection (free)
- GitHub Actions

### Setup Data Pipeline

To use this repository as a standalone data pipeline, simply fork this repo, and set the secret variables and the GitHub action will run automatically every 3 hour. This will sync the specified repo's GitHub data to TiDB Cloud.

![image](https://user-images.githubusercontent.com/63877/233130431-cfe9884a-a58e-45de-a702-98b41a370ceb.png)

Environment Secrets

To use this repository, you will need to set the following secrets on GitHub:

| Secret Name | Description |
| --- | --- |
| `ACCESS_TOKEN` | A personal access token provided by GitHub, which can be obtained from [Sign in to GitHub · GitHub](https://github.com/settings/tokens). |
| `DATABASE_URL` | The MySQL connection information in URI format for TiDB Cloud. You will need to register and create a serverless cluster on [https://tidb.cloud](https://tidb.cloud/), and the URI format should contain the necessary information for connecting to the cluster. An example of the DATABASE_URL format is: mysql2://xxx.root:password@hostxx.tidbcloud.com:4000/db_name |
| `REPO_FULL_NAME` | The full name of the repository, for example: `vercel/next.js`, you can also set multiple repository full names, such as: `vercel/next.js,vercel/vercel` or `remix-run/remix,vercel/next.js`. |


⚠️ Make sure you enable GitHub Action for this forked repo.

![image](https://user-images.githubusercontent.com/63877/233132878-b6879d1c-272b-4db5-93f6-587f4d64b72a.png)


## Usage

1. Fork the Repo-Track-Pipeline repository.
2. Enable GitHub Actions manually, as shown in the image.
3. Set up a personal access token in GitHub.
4. Set up a TiDB Cloud connection.
5. Add the access token and database URL to your GitHub repository secrets.

Note: Repo-Track-Pipeline is crash-safe. If the pipeline fails for any reason, you can manually run GitHub Actions again without worrying about data corruption. Additionally, GitHub Actions will automatically run every 3 hours.

## Contributing

Contributions to Repo-Track-Pipeline are welcome! If you find a bug or have an idea for a new feature, please open an issue or submit a pull request.

## License

Repo-Track-Pipeline is licensed under the [MIT License](https://github.com/hooopo/repo-track-pipeline/blob/main/LICENSE).
