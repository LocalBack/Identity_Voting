const IdentityManager = artifacts.require("IdentityManager");
const AnonymousVoting = artifacts.require("AnonymousVoting");

module.exports = async function(deployer, network, accounts) {
  // Set gas price to 0.35 gwei
  const gasPrice = web3.utils.toWei('0.75', 'gwei');
  
  // Deploy IdentityManager
  await deployer.deploy(IdentityManager, {
    gas: 2000000,
    gasPrice: gasPrice
  });
  
  const identityManager = await IdentityManager.deployed();
  
  // Minimal proposal names
  const proposalNames = [
    web3.utils.asciiToHex("P1"),
    web3.utils.asciiToHex("P2")
  ];

  // Deploy AnonymousVoting
  await deployer.deploy(
    AnonymousVoting,
    identityManager.address,
    proposalNames,
    3600, // 1 hour voting duration
    {
      gas: 3000000,
      gasPrice: gasPrice
    }
  );
};