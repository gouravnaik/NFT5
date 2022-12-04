// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require('hardhat');

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Nft5 = await hre.ethers.getContractFactory('Nft5');
  const nft5 = await Nft5.deploy(
    '0xf0511f123164602042ab2bCF02111fA5D3Fe97CD',
    'NFT5 - ETHINDIA',
    'NFT5'
  );

  await nft5.deployed();

  console.log('NFT5 deployed to:', nft5.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
