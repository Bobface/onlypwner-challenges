pragma solidity 0.8.21;

import {IERC721, IERC721TokenReceiver, IERC721Errors} from "./interfaces/IERC721.sol";
import {IERC165} from "./interfaces/IERC165.sol";

contract Vault is IERC165, IERC721, IERC721Errors {
    address public owner;
    address public operator;

    constructor(address _owner) {
        _changeOwnership(_owner);
    }

    receive() external payable {}

    function balanceOf(address _owner) public view returns (uint256) {
        if (_owner == address(0)) {
            revert ERC721InvalidOwner(address(0));
        }
        return _owner == owner ? 1 : 0;
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        _requireZero(tokenId);
        return owner;
    }

    function approve(address to, uint256 tokenId) public {
        _requireZero(tokenId);
        if (msg.sender != owner) {
            revert ERC721InvalidApprover(msg.sender);
        }

        operator = to;
        emit Approval(owner, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
        _requireZero(tokenId);

        if (owner != from) {
            revert ERC721IncorrectOwner(from, tokenId, owner);
        }

        address spender = msg.sender;
        if (spender != owner && spender != operator) {
            revert ERC721InsufficientApproval(spender, tokenId);
        }

        address _owner = owner;
        address _operator = operator;

        _changeOwnership(to);

        _owner.call{value: address(this).balance}("");

        bytes4 retval = IERC721TokenReceiver(to).onERC721Received(_operator, from, tokenId, data);
        if(retval != IERC721TokenReceiver.onERC721Received.selector) {
            revert ERC721InvalidReceiver(to);
        }
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        _requireZero(tokenId);
        return operator;
    }

    function supportsInterface(bytes4 interfaceId) public pure override returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId;
    }

    function setApprovalForAll(address _operator, bool approved) public {
        if(approved) {
            approve(_operator, 0);
        } else if (_operator == operator) {
            operator = owner;
        }
    }

    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return (_owner == owner && _operator == operator);
    }

    function _requireZero(uint256 tokenId) internal pure {
        if (tokenId != 0) {
            revert ERC721NonexistentToken(tokenId);
        }
    }

    function _changeOwnership(address newOwner) internal {
        if (newOwner == address(0) || newOwner.code.length > 0) {
            revert ERC721InvalidReceiver(newOwner);
        }

        owner = newOwner;
        operator = newOwner;
    }
    
}
