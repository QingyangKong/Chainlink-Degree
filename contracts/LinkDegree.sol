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

    mapping(address => bool) public whitelist;
    string constant INITIAL_METADAT = "ipfs://QmW8h5Gtw32yvtfEugFRyDWAaAVALQeLB5iRif6neYDJ2Q";

    // event to record a certificate is granted to an address
    event Attest(address indexed to, uint256 indexed tokenId);

    // event to record a certificate is revoked from an address
    event Revoke(address indexed to, uint256 indexed tokenId);

    constructor() ERC721("LinkDegree", "LD") {}

    // the address to be granted to mint a non-transferable token
    function safeMint() public {
        require(whitelist[msg.sender], "You are not eligible yet");
        require(balanceOf(msg.sender) < 1, "You can only have one SBT");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, INITIAL_METADAT);
    }


    function addToWhitelist(address[] calldata toAddAddrs) 
        external 
        onlyOwner
    {
        for(uint256 i = 0; i < toAddAddrs.length; i++) {
            whitelist[toAddAddrs[i]] = true;
        }
    }

    function removeFromWhitelist(address[] calldata toRemoveAddrs) 
        external 
        onlyOwner 
    {
        for(uint256 i = 0; i < toRemoveAddrs.length; i++) {
            delete whitelist[toRemoveAddrs[i]];
        }
    }

    function updateTokenUri(uint256 tokenId, string memory metadata) 
        external 
        onlyOwner
    {
        _setTokenURI(tokenId, metadata);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        // to make sure the token can only be granted or revoked
        // 
        require(from == owner() || from == address(0) || to == address(0), "Link Degree is non-transferable");
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal override 
    {
        if (from == address(0) || from == owner()) {
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
        address addrToRemove = ownerOf(tokenId);
        _burn(tokenId);
        delete whitelist[addrToRemove];
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