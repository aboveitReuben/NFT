//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Web3TestContract is ERC721URIStorage, Ownable {

    using Strings for string;
    using Counters for Counters.Counter;

    string private _baseTokenURI;
    Counters.Counter private _tokenIds;
    uint256 public MAX_SUPPLY = 10000;
    uint256 public maxMint = 5;
    bool public revealed = false;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}


    
    // metadata URI
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    // Mint
    function mint(string memory tokenURI)
        public
        returns (uint256)
    {
        require(MAX_SUPPLY > _tokenIds.current());
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    //reveal
    function setReavealed(bool _revealed) 
    public 
    onlyOwner
    {
        revealed = _revealed;
    }
}