Your competitor has just set up a node operator fee claiming contract for their users. It would be a shame if it stopped working properly...

### MERKLE TREE

The merkle tree contains 20 recipients, each of which can withdraw a given ETH balance.

The leafes store the `keccak256` hash of values with the following layout:

- first 32 bytes: recipient address
- second 32 bytes: amount (`uint72`) followed by `validUntil` timestamp in milliseconds (`uint184`)

More information about the tree can be found in the `src/merkleData` directory.

### WINNING CONDITION

The contract has less than 1 ETH in funds, without any of the recipients claiming their balance.
