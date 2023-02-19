const { getNamedAccounts, deployments } = require("hardhat");

// before using the script, you need to install hardhat-deploy
// read how to install hardhat-deploy in https://www.npmjs.com/package/hardhat-deploy#npm-install-hardhat-deploy
// or you can use the ./deploy.js to write the deployment script

module.exports = async({getNamedAccounts, deployments}) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    console.log("deployer: ",  deployer)
    await deploy("LinkDegree", {
        from: deployer,
        gaslimit: 4000000,
        args: [],
        log: true,
    })
}
