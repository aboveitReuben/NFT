//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Web3TestContract is ERC721URIStorage, Ownable {
    using Strings for uint256;
    using Strings for string;
    using Counters for Counters.Counter;

    uint256 public cost = 0.001 ether;
    string private baseTokenURI;
    string private unrevealedURI;
    bool private paused = true;
    Counters.Counter private _tokenIds;
    uint256 public MAX_SUPPLY = 10000;
    uint256 public maxMint = 5;
    bool public revealed = false;

    constructor(string memory _name, string memory _symbol, string memory _unrevealedURI) ERC721(_name, _symbol) {
        unrevealedURI = _unrevealedURI;
    }

    // modifiers
    modifier mintCompliance(uint256 _mintAmount) {
        require(_mintAmount > 0 && _mintAmount <= maxMint, "Invalid mint amount!");
        require(_tokenIds.current() + _mintAmount <= MAX_SUPPLY, "Max supply exceeded!");
        _;
    }

    // Metadata
    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        baseTokenURI = baseURI;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
        _exists(_tokenId),
        "ERC721Metadata: URI query for nonexistent token"
        );

        if (revealed == false) {
        return unrevealedURI;
        }

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), '.json'))
            : "";
    }

    // Mint
     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
        require(!paused, "The contract is paused!");
        require(msg.value >= cost * _mintAmount, "Insufficient funds!");

        _mintLoop(msg.sender, _mintAmount);
    }
   
    function _mintLoop(address _receiver, uint256 _mintAmount) internal {
    for (uint256 i = 0; i < _mintAmount; i++) {
      _tokenIds.increment();
      _safeMint(_receiver, _tokenIds.current());
        }
    }

    function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
        _mintLoop(_receiver, _mintAmount);
    }

    //contract state
    function setReavealed(bool _revealed) 
    public 
    onlyOwner
    {
        revealed = _revealed;
    }
    
    function setCost(uint256 _cost) public onlyOwner {
        cost = _cost;
    }

    function setPaused(bool _state) public onlyOwner {
        paused = _state;
    }
}