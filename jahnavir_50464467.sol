//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract TradingMeteorFragment is ERC721 {
    // Define a struct to store information about each meteor fragment
    struct MeteorFragment {
        string name;
        uint256 rarity; // Rarity score (0-100)
        uint256 price; // Price in ether
    }

    // Array of all meteor fragments
    MeteorFragment[] public meteorFragments;

    // Mapping from meteor fragment index to owner address
    mapping (uint256 => address) public meteorFragmentToOwner;

    constructor() ERC721("TradingMeteorFragment", "TMF") {}

    // Function to create a new meteor fragment and tokenize it
    function createMeteorFragment(string memory _name, uint256 _rarity, uint256 _price) public {
        uint256 meteorFragmentId = meteorFragments.length;
        meteorFragments.push(MeteorFragment(_name, _rarity, _price));
        _mint(msg.sender, meteorFragmentId);
        meteorFragmentToOwner[meteorFragmentId] = msg.sender;
    }

    // Function to buy a meteor fragment
    function buyMeteorFragment(uint256 _meteorFragmentId) public payable {
        require(meteorFragmentToOwner[_meteorFragmentId] != address(0), "Meteor fragment does not exist");
        address payable owner = payable(meteorFragmentToOwner[_meteorFragmentId]);
        require(msg.value >= meteorFragments[_meteorFragmentId].price, "Insufficient funds");
        _transfer(owner, msg.sender, _meteorFragmentId);
        meteorFragmentToOwner[_meteorFragmentId] = msg.sender;
        owner.transfer(msg.value);
    }
    // Function to sell a meteor fragment
    function sellMeteorFragment(uint256 meteorFragmentId, uint256 price) public {
        require(_exists(meteorFragmentId), "meteorFragment Id does not exist");
        require(msg.sender == ownerOf(meteorFragmentId), "Only the owner can sell");
        meteorFragments[meteorFragmentId].price=price;
    }
}
