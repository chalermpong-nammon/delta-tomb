require("@nomiclabs/hardhat-waffle");
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
const { FANTOM_API_URL, ROPSTEN_API_URL, RINKEBY_API_URL, PRIVATE_KEY } = process.env;

// The next line is p
// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.
require("./tasks/faucet");

// If you are using MetaMask, be sure to change the chainId to 1337
module.exports = {
  solidity: {
    compilers:[
    {
        version: "0.7.3",
    },
    {
      version:"0.8.0"
    }
    ]
  },
  networks: {
    hardhat: {
      chainId: 31337
    },
    fantom: {
      url: FANTOM_API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    ropsten: {
      url: ROPSTEN_API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
    rinkeby: {
      url: RINKEBY_API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    },
  }
};
