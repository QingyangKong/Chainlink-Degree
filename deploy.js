// run yarn hardhat run deploy.js to deploy the contract
async function main() {
  const myContract = await hre.ethers.getContractFactory("LinkDegree")
  myContractDeployed = await myContract.deploy();
  await myContractDeployed.deployed();
  console.log("Contract LinkDegree has been deployed at ", myContractDeployed.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })