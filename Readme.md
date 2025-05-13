# Setup
- Install nvm 
- install require version of node


- Install required packages:
    ```
    npm ci
    ```
 - Run Application
    ```
    pm2 start ecosystem.config.js --env prod
    ```


There is deploy.sh file as well which we currently using for deploy in ec2
bash deploy <ENV NAME> <BRANCH NAME>