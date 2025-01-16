const IdentityManager = artifacts.require("IdentityManager");
const AnonymousVoting = artifacts.require("AnonymousVoting");

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

module.exports = async function(deployer, network, accounts) {
  const maxRetries = 5;
  let currentTry = 0;

  while (currentTry < maxRetries) {
    try {
      console.log(`Deployment attempt ${currentTry + 1} of ${maxRetries}`);
      
      // Deploy IdentityManager
      console.log('Deploying IdentityManager...');
      await deployer.deploy(IdentityManager, {
        gas: 3000000,
        gasPrice: web3.utils.toWei('0.75', 'gwei')
      });
      const identityManager = await IdentityManager.deployed();
      console.log('IdentityManager deployed at:', identityManager.address);

      // Wait between deployments
      await sleep(10000); // 10 seconds

      // Deploy AnonymousVoting
      console.log('Deploying AnonymousVoting...');
      const proposalNames = [
        web3.utils.asciiToHex("P1"),
        web3.utils.asciiToHex("P2")
      ];
      
      await deployer.deploy(
        AnonymousVoting,
        identityManager.address,
        proposalNames,
        3600,
        {
          gas: 3000000,
          gasPrice: web3.utils.toWei('0.75', 'gwei')
        }
      );
      
      const anonymousVoting = await AnonymousVoting.deployed();
      console.log('AnonymousVoting deployed at:', anonymousVoting.address);
      
      // Deployment successful, exit loop
      break;
    } catch (error) {
      console.error(`Deployment attempt ${currentTry + 1} failed:`, error.message);
      currentTry++;
      
      if (currentTry === maxRetries) {
        throw new Error('Max retry attempts reached. Deployment failed.');
      }
      
      // Wait before retrying
      console.log('Waiting 30 seconds before retrying...');
      await sleep(30000);
    }
  }
};