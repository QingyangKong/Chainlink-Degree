// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract LinkDegree is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    // event to record a certificate is granted to an address
    event Attest(address indexed to, uint256 indexed tokenId);

    // event to record a certificate is revoked from an address
    event Revoke(address indexed to, uint256 indexed tokenId);

    constructor() ERC721("LinkDegree", "LD") {}

    // the address to be granted to mint a non-transferable token
    function safeMint() public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, "");
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        // to make sure the token can only be granted or revoked
        require(from == address(0) || to == address(0), "Link Degree is non-transferable");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal override 
    {
        if (from == address(0)) {
            emit Attest(to, firstTokenId);
        } else if(to == address(0)) {
            emit Revoke(to, firstTokenId);
        }
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    /**
     * there are 2 functions the token can be burned
     * one is revoked that is expected to be called by owner
     * the other one is burn that is expected to be called by holder
     * burn is implemented by ERC721Burnable.sol
     * */ 
    function revoke(uint256 tokenId) external onlyOwner {
        require(ownerOf(tokenId) == msg.sender);
        _burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}