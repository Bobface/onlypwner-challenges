pragma solidity 0.8.20;

library MerkleProof {
    function verifyProof(
        bytes32 leaf,
        bytes32 root,
        bytes32[] memory proof
    ) external pure returns (bool) {
        bytes32 currentHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            currentHash = _hash(currentHash, proof[i]);
        }
        return currentHash == root;
    }

    function _hash(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return
            a < b
                ? keccak256(abi.encodePacked(a, b))
                : keccak256(abi.encodePacked(b, a));
    }
}
