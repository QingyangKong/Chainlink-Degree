# Chainlink-Degree

# Instruction to use the samples
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
Add the contract name in `./deploy.js`.

Then run command
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

## Certificates issued
### Chainlink bootcamp certificate
Address is: `0xb054CAf794cd34a41BDBD3C852eC68f9a54a1C4f`(Polygon mainnet).

You can see all certificates at: https://opensea.io/collection/linkdegree-1 <br><br>
Metadata for VRF: https://ipfs.filebase.io/ipfs/QmUd9weBfoid8g2aWYPQNJhRXaMTg2k3ZKjcFjLydAX7iz <br><br>
Metadata for VRF and Functions: https://ipfs.filebase.io/ipfs/QmNvVtkipuqv8WbBxB7cRPhqXGZho4hzmrPemCkMtKXqsp <br><br>
Metadata for CCIP: https://ipfs.filebase.io/ipfs/QmYuu6gx4xnHE76z8z4KF8KoLfPwyLcoPHLuTnGQRs7Gmi/QmdbLowN4pPaPXP4269YpbZFzFxaieYhkN6KtRL96bS8Ji
### Chainlink Learning Path certificate
Address is: `0x5a1805ffd9cfa1f79fb3cfced12e02e342672e2e`(Polygon mainnet).

You can see all certificate at: https://opensea.io/collection/linkdegree