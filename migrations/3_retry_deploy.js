const IdentityManager = artifacts.require("IdentityManager");
const AnonymousVoting = artifacts.require("AnonymousVoting");

module.exports = async function(deployer, network, accounts) {
  console.log('Starting deployment...');
  console.log('Network:', network);
  console.log('Account:', accounts[0]);

  try {
    // Get current gas price and calculate a safe higher price
    const currentGasPrice = await web3.eth.getGasPrice();
    const baseGasPrice = web3.utils.toBN(currentGasPrice);
    const multiplier = web3.utils.toBN(3); // Multiply by 3 to ensure we're above base fee
    const gasPriceToUse = baseGasPrice.mul(multiplier);

    console.log('Current gas price:', web3.utils.fromWei(currentGasPrice, 'gwei'), 'gwei');
    console.log('Using gas price:', web3.utils.fromWei(gasPriceToUse, 'gwei'), 'gwei');

    // Deploy with specific parameters
    const deployParams = {
      from: accounts[0],
      gas: 3000000,
      gasPrice: gasPriceToUse,
      maxFeePerGas: web3.utils.toWei('15', 'gwei'), // Set maximum fee to 15 gwei
      maxPriorityFeePerGas: web3.utils.toWei('2', 'gwei') // Set priority fee
    };

    // Deploy IdentityManager
    console.log('Deploying IdentityManager...');
    await deployer.deploy(IdentityManager, deployParams);
    
    const identityManager = await IdentityManager.deployed();
    console.log('IdentityManager deployed at:', identityManager.address);

    // Wait between deployments
    console.log('Waiting 30 seconds...');
    await new Promise(resolve => setTimeout(resolve, 30000));

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
      deployParams
    );

    const anonymousVoting = await AnonymousVoting.deployed();
    console.log('AnonymousVoting deployed at:', anonymousVoting.address);
    console.log('Deployment completed successfully!');

  } catch (error) {
    console.error('Deployment failed:', error);
    throw error;
  }
};