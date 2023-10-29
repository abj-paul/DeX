import { ethers } from "hardhat";

async function main() {
  // const lockedAmount = ethers.utils.parseEther("1");

  const Greeter = await ethers.getContractFactory("Greeter");
  // const greeting = await Greeting.deploy("Hello world", { value: lockedAmount });
  const greeter = await Greeter.deploy("Hello world");

  await greeter.waitForDeployment();

  greeter.getAddress()
  .then((address)=>{
    console.log("Greeting contract deployed to: ", address);
  })
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});