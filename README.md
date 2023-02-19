# Chainlink-Degree

## 1 clone the repo
```
git clone https://github.com/QingyangKong/Chainlink-Degree.git
```

## 2 install dependencies
```
npm install
```

## 3 update the hardhat.config.js
add the private key, rpc url and etherscan key in the file `hardhat.config.js.example`

Change the file name from `hardhat.config.js.example` to `hardhat.config.js`

## 4 deploy the contract
```
yarn hardhat deploy --network goerli
```
or 
```
yarn hardhat run ./deploy.js
```

## 5 verify the contract
```
yarn hardhat --network goerli verify <contract addr>
```