module.exports = {
  apps: [
    {
      name: "demo-app",
      script: "index.js",
      instances: "max",
      exec_mode: "cluster",
      autorestart: true,
      env_dev: {
        NODE_ENV: "dev",
        PORT: 4005,
      },
      env_prod: {
        NODE_ENV: "prod",
        PORT: 6001,
      },
    },
  ],
};
