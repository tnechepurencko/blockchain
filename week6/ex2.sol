// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract App is ERC721 {
    struct Location {
        int256 long;
        int256 lat;
        int256 rad;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Location[] private locations;
    int256 public constant earthRad  = 6371;

    constructor() public ERC721("App", "ITM") {}

    function awardItem(address player, string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);

        return newItemId;
    }

    function addLocation(int256 long, int256 lat, int256 rad) public {
            int256 pi = 4;
            Location memory loc = Location(long * pi / 180, lat * pi / 180, rad * pi / 180);
            checkInterserctions(loc);
            locations.push(loc);
        
    }

    function checkInterserctions(Location memory loc) private view {
        for (uint256 i = 0; i < locations.length; i++) { 
            require(calculateDistance(loc, locations[i]) > loc.rad + locations[i].rad, "Land overlapping!");
        } 
    }

    function calculateDistance(Location memory loc1, Location memory loc2) private pure returns (int256) {
        int256 x1 = getXCartesian(loc1);
        int256 y1 = getYCartesian(loc1);
        int256 z1 = getZCartesian(loc1);
        
        int256 x2 = getXCartesian(loc2);
        int256 y2 = getYCartesian(loc2);
        int256 z2 = getZCartesian(loc2);

        return sqrt((x1 - x2)**2 + (y1 - y2)**2 + (z1 - z2)**2);
    }

    function sqrt(int256 num) private pure returns (int256 y) {
        int256 z = (num + 1) / 2;
        y = num;
        while (z < y) {
            y = z;
            z = (num / z + z) / 2;
        }
    }

    function getXCartesian(Location memory loc) private pure returns (int256) {
        return earthRad * cos(loc.lat) * cos(loc.long);
    }

    function getYCartesian(Location memory loc) private pure returns (int256) {
        return earthRad * cos(loc.lat) * sin(loc.long);
    }

    function getZCartesian(Location memory loc) private pure returns (int256) {
        return earthRad * sin(loc.lat);
    }


    function sin(int256 num) private pure returns (int256) {
        int256 res = num;
        int256 sign;
        int256 pow;
        for (int256 i = 0; i < 20; i++) { 
            sign = power(-1, i + 1);
            pow = (i + 1) * 2 + 1;
            res = sign * power(num, pow) / factorial(pow);
        } 
        return res; 
    }

    function cos(int256 num) private pure returns (int256) {
        int256 res = 1;
        int256 sign;
        int256 pow;
        for (int256 i = 0; i < 20; i++) { 
            sign = power(-1, i + 1);
            pow = (i + 1) * 2;
            res = sign * power(num, pow) / factorial(pow);
        } 
        return res; 
    }

    function factorial(int256 num) public pure returns(int256) {
        int256 res = 1;
        for (int256 i = 2; i <= num; i++) {
            res *= i;
        }
        return res;
    }

    function power(int256 num, int256 pow) public pure returns(int256) {
        int256 res = 1;
        for (int256 i = 1; i <= pow; i++) {
            res *= num;
        }
        return res;
    }
}