This is a dummy challenge with the purpose of demonstrating how to interact with and solve challenges. If you are new, make sure to read the **DOCUMENTATION** linked to at the top of the page before getting started.

Interacting with challenges on ONLYPWNER is very similar to interacting with deployed smart contracts on-chain, just that we are connecting to a sandbox environment instead of a real blockchain. The documentation lists a variety of tools you can use to do so. In this tutorial, we will use _Forge Scripts_.

### 1. FINDING THE VULNERABILITY

Looking at the code listing at the bottom of this page, we can see that the `Deploy.sol` script sets up the `Tutorial` contract with an initial balance of 10 ether. The winning condition, which can be found in `IsSolved.sol`, is to remove all funds from the `Tutorial` contract.

The `Tutorial` contract itself has a function `callMe` that simply transfers all funds to the caller. So, to solve this challenge, we simply need to invoke `callMe` on the `Tutorial` contract.

### 2. SETTING UP THE FORGE ENVIRONMENT

On your local machine, run `forge init` in an empty directory to create a new project. Forge will initialize a default folder and file structure. We can ignore most of it, the only important directory for us is `script`. In there, you will find a default script called `Counter.s.sol`. You can safely delete this file.

### 3. CREATING THE SOLUTION SCRIPT

Next, we create our solution document in our local `script` directory. You can call it whatever you like, for example `script/SolveTutorial.sol`. In there, we simply call the `callMe` method of `Tutorial`:

```solidity
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";

interface ITutorial {
    function callMe() external;
}

contract SolveTutorial is Script {
    function run() public {
        vm.startBroadcast();
        ITutorial tutorial = ITutorial(/* TODO */);
        tutorial.callMe();
    }
}
```

### 4. LAUNCHING THE CHALLENGE

Now that we are ready to call the `Tutorial` contract, we need its address and a RPC we can communicate with. Click the yellow **LAUNCH** button, and you will receive an RPC URL, the contract address, and a user private key and address. Insert the contract address into the `SolveTutorial` script to replace the `/* TODO */` comment.

### 5. RUNNING THE SOLUTION SCRIPT

We are ready to execute the script. Insert your values into the command below and run it. **DO NOT** use your real private key. Instead, use the one you received when you launched the challenge. This private key is also not expected to ever change, and is constant across challenges.

```bash
forge script \
    --broadcast \ # To actually send the transactions
    --rpc-url <YOUR RPC URL HERE> \ # The RPC to communicate with
    --private-key be0a5d9f38057fa406c987fd1926f7bfc49f094dc4e138fc740665d179e6a56a \ # The generated private key
    --with-gas-price 0 \ # Do not pay for gas
    SolveTutorial # Execute our solution script
```

### 6. CHECKING FOR SUCCESS

Finally, we can now press the **CHECK** button. If all went well, it turns green, and you have solved the challenge!
