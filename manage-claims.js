const hre = require("hardhat");

async function main() {
  const [governor, user] = await hre.ethers.getSigners();
  
  const Pool = await hre.ethers.getContractFactory("InsurancePool");
  const pool = await Pool.deploy("0x..."); // Token address

  await pool.waitForDeployment();
  console.log("Insurance Pool deployed to:", await pool.getAddress());

  // In a real scenario, governor would validate the claim off-chain
  // then call payoutClaim(0) to release funds.
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
