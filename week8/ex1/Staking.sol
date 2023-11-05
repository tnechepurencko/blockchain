// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract Staking is ReentrancyGuard {
    IERC20 public s_stakingToken;
    IERC20 public s_rewardToken;
    address public s_rewarder;

    mapping (uint256 => ERC20) public collections;
    uint256[] collectionsFilledTimestamps;
    mapping (uint256 => uint256) public collectionsLength;
    StakeItem[] public items;
    uint256 lastTokenIndex = 0;

    struct StakeItem {
        ERC20 collection;
        uint256 tokenId;
        address owner;
        uint256 lastRewardTimestamp;
    }

    constructor(address stakingToken, address rewardToken, address rewarder) {
        s_stakingToken = IERC20(stakingToken);
        s_rewardToken = IERC20(rewardToken);
        s_rewarder = rewarder;
    }

    function addCollection(ERC20 collection) public {
        collections[lastTokenIndex] = collection;
        collectionsLength[lastTokenIndex] = 0;
        lastTokenIndex++;
    }

    modifier collectionExists(uint256 collectionId) {
        require(address(collections[collectionId]) == address(0), "wrong collection id");
        _;
    }
    
    modifier newItemsAllowed(uint256 collectionId) {
        require(collectionsLength[collectionId] < 11, "trying to exceed the collection length limit");
        _;
    }

    function addItem(uint256 collectionId, uint256 tokenId) public collectionExists(collectionId) newItemsAllowed(collectionId) {
        ERC20 collection = collections[collectionId];
        collection.transferFrom(msg.sender, address(this), tokenId);
        items.push(StakeItem(collection, tokenId, msg.sender, block.timestamp));

        if (collectionsLength[collectionId] == 10) {
            collectionsFilledTimestamps.push(block.timestamp);
        }
    }

    function getReward() public {
        for (uint i = 0; i < items.length; i++) {
            if (items[i].owner == msg.sender) {
                uint256 rewardPerItem = ((block.timestamp - items[i].lastRewardTimestamp) / 60) * 100;
                s_rewardToken.transferFrom(s_rewarder, msg.sender, rewardPerItem);
                items[i].lastRewardTimestamp = block.timestamp;
            }
        }

        for (uint i = 0; i < collectionsFilledTimestamps.length; i++) {
            if (items[i].owner == msg.sender) {
                uint256 rewardPerCollection = ((block.timestamp - collectionsFilledTimestamps[i]) / 60) * 10000;
                s_rewardToken.transferFrom(s_rewarder, msg.sender, rewardPerCollection);
                collectionsFilledTimestamps[i] = block.timestamp;
            }
        }
    }


}

contract RewardToken is ERC20 {
    constructor() ERC20("Reward Token", "RT") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}