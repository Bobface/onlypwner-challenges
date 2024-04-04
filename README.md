# ONLYPWNER Challenges

![Banner](./banner.jpg)

Challenges for the [ONLYPWNER CTF Platform](https://onlypwner.xyz).

This repository welcomes submissions via PRs. If you have an idea for an interesting challenge and want it featured on the site, please carefully read the sections below to get started.

If something remains unclear, hop on the [ONLYPWNER Discord server](https://discord.gg/tukqhC3EUH) to reach out for help!

# Creating your own challenge
### What makes a good challenge?
The platform values quality over quantity. Each new challenge should introduce a new concept, technique, or unique structure, and shouldn't just be a simple repetition of previous challenges. There can certainly be multiple challenges that involve the same type of bug, for example a re-entrancy vulnerability. However, each one should present it in a different context or require a distinct approach to solve it.

A degree of realism is also wished for. Each challenge is accompanied by a description that sets the scene, and the source code should be built in a way that resembles a real deployment. For example, a challenge where the user has to drain a yield-farming `Vault` of its funds is more engaging than a `HackMe` contract where the `challengeSolvedSuccessfully` flag has to be set to `true`.

It's a good idea to scroll through (or also solve!) a couple of challenges on the site first to get a feeling of the existing challenges.

### Choosing the difficulty
You can make your challenge as easy or hard as you please. The difficulty will be on a scale of 1 to 5. There are two main factors that influence the final difficulty:
1. How hard it is to identify the issue
2. How hard it is to exploit the issue

*Examples*:
1. A missing `onlyOwner` modifier on a method can be easily identified by casually scrolling through the source code. A bug involving Solidity's behind-the-scenes memory management is harder to find.
2. Calling a method with a parameter that overflows an integer and thus solves the challenge is quite easy to do. Having to deploy multiple custom contracts with sophisticated logic is hard.

### The execution environment
Challenge instances are executed on a local EVM devnet starting with a clean state on block 0. While you can use challenges that involve external protocols (e.g. Uniswap), keep in mind that you will have to deploy them yourself. 

## What not to do
- Leaking information about the challenge solution
- Challenges that involve unfixed bugs in real deployments
- Challenges that negatively describe real persons or entities
- Huge challenges with lots of source files and lines of code

## Submitting your challenge
Once you are ready to submit, create a PR to the `dev` branch of this repository. 

**Please also send an email** to *bobface at onlypwner dot xyz* with
- your challenge name in the subject
- a brief description of the challenge bug and solution in the body
- and a solution PoC in the form of a forge script in the attachment

This let's me verify that the challenge is working as intended.

**DO NOT** leak information about the challenge solution anywhere, including in the PR description, challenge files, commit message, etc. Since this is a public repository, this means your challenge would need to be rejected.


## Challenge files
Each challenge consists of some metadata files, source code, and administration code. It's recommended to briefly look through some challenges in this repo first to get a feeling for the structure. The containing folder should be named `[your ONLYPWNER username]-[challenge name]`

#### `manifest.json`
Contains the following JSON fields:
- `name`: The name of the challenge
- `author`: The author of the challenge (your ONLYPWNER username)
- `xHandle`: Your X/Twitter handle without the `@`
- `difficulty`: 1-5
- `hardfork`: The hardfork the challenge should run on. Use `latest` for the default.
- `uuid`: A unique UUIDv4. You can use an online tool [like this one](https://www.uuidgenerator.net/version4) to generate it.
- `version`: Should be `1` for new submissions.

#### `DESCRIPTION.md`
A markdown file that sets the scene. The last lines should be the `### WINNING CONDITION` section that briefly describes what needs to be achieved to solve the challenge.

#### `dependencies.txt` (optional)
If your challenge requires external dependencies (e.g. OpenZeppelin contracts), this file lists them line-by-line together with their commit hash. For example: 
```
https://github.com/Uniswap/v2-periphery@0335e8f7e1bd1e8d8329fd300aea2ef2f36dd19f
https://github.com/Uniswap/v2-core@ee547b17853e71ed4e0101ccfd52e70d5acded58
https://github.com/OpenZeppelin/openzeppelin-contracts@812404cee89cd91d46f6234d03451b07eebf2e35
https://github.com/Uniswap/solidity-lib@c01640b0f0f1d8a85cba8de378cc48469fcfd9a6
```

These will be automatically installed when the challenge is compiled. 

Note: Please keep external dependencies to a minimum. Generally, only well-known and established libraries are allowed to be included.

#### `remappings.txt` (optional)
A forge remappings file if needed. For example:
```
@uniswap/v2-core=lib/v2-core
@uniswap/lib=lib/solidity-lib
```

#### `script/*`
There are two scripts that set up and check a challenge. Each script is a forge script, and can make use of special environment variables accessible via `vm.envAddress("...")`:
- `USER`: The address the user will use to send transactions
- `SCRIPTER`: The address the scripts use to send transactions

##### `script/Deploy.sol`
This script is executed to deploy a new instance of your challenge. It's structure should be:
```
pragma solidity ...;

import {SomeContract} from "../src/SomeContract.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        SomeContract someContract = new SomeContract();

        console.log("address:SomeContract", address(someContract));
    }
}
```

You can execute calls, send funds, and do whatever is required to set up the environment in this script. Most importantly, it must log the necessary  addresses at the end. They will be displayed to the user on the UI and also be fed back into the `IsSolved` script.

##### `script/IsSolved.sol`
This script checks whether the challenge is solved. It should have the following structure:

```
pragma solidity ...;

import {SomeContract} from "../src/SomeContract.sol";
import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

contract IsSolved is Script {
    function run() external view {
        // Your logged addresses from Deploy.sol are available
        address someContract = vm.envAddress("SomeContract");

        if (someContract.balance == 0) {
            // Winning condition
            console.log("is-solved:true");
        } else {
            console.log("is-solved:false");
        }
    }
}
```

You can also execute state-altering operations in this script (like sending funds). Just keep in mind that this script can be executed multiple times in the same environment, when the user clicks "CHECK" repeatedly. 

#### `src/*.sol`
Place your challenge source files here. 


#### `src/interfaces/*.sol`
You **must** include `interface`s for your source contracts. This is a convenience for the users interacting with the challenges.
