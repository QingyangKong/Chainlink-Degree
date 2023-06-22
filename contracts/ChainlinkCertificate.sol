// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ChainlinkCertificate is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping(address => bool) public whitelistForL1;
    mapping(address => bool) public whitelistForL2;
    string constant L1_METADATA = "https://ipfs.filebase.io/ipfs/QmUd9weBfoid8g2aWYPQNJhRXaMTg2k3ZKjcFjLydAX7iz";
    string constant L2_METADATA = "https://ipfs.filebase.io/ipfs/QmNvVtkipuqv8WbBxB7cRPhqXGZho4hzmrPemCkMtKXqsp";

    // event to record a certificate is granted to an address
    event Attest(address indexed to, uint256 indexed tokenId);

    // event to record a certificate is revoked from an address
    event Revoke(address indexed to, uint256 indexed tokenId);

    constructor() ERC721("LinkDegree", "LD") {}

    // the address to be granted to mint a non-transferable token
    function mint(uint8 level) public {
        require(level == 1 || level == 2, "Level can only be 1 or 2");
        require(balanceOf(msg.sender) < 1, "You can only have one Certificate");
        if(level == 1) {
            require(whitelistForL1[msg.sender], "You are not eligible yet");
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenId);
            _setTokenURI(tokenId, L1_METADATA);
        } else {
            require(whitelistForL2[msg.sender], "You are not eligible yet");
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenId);
            _setTokenURI(tokenId, L2_METADATA);
        }
    }

    function mintForOther(uint8 level, address developer) public onlyOwner{
        if(level == 1) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(developer, tokenId);
            _setTokenURI(tokenId, L1_METADATA);
        } else {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(developer, tokenId);
            _setTokenURI(tokenId, L2_METADATA);
        }
    }


    function addToWhitelist(address[] calldata toAddAddrs, uint8 level) 
        external 
        onlyOwner
    {
        require(level == 1 || level == 2, "level can only be 1 or 2");
        if(level == 1) {
            for(uint256 i = 0; i < toAddAddrs.length; i++) {
                whitelistForL1[toAddAddrs[i]] = true;
            }
        } else {
            for(uint256 i = 0; i < toAddAddrs.length; i++) {
                whitelistForL2[toAddAddrs[i]] = true;
            }
        }
    }

    function removeFromWhitelist(address[] calldata toRemoveAddrs, uint8 level) 
        external 
        onlyOwner 
    {
        require(level == 1 || level == 2, "level can only be 1 or 2");
        if(level == 1) {
            for(uint256 i = 0; i < toRemoveAddrs.length; i++) {
              delete whitelistForL1[toRemoveAddrs[i]];
            }    
        } else {
            for(uint256 i = 0; i < toRemoveAddrs.length; i++) {
              delete whitelistForL2[toRemoveAddrs[i]];
            }
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