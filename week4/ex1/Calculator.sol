// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract Calculator {
    uint X;
    uint Y;

    constructor() {
        X = 5;
        Y = 2;
    }

    function setValues(uint _X, uint _Y) external {
        X = _X;
        Y = _Y;
    }

    function plus() view external returns(uint) {
        return X + Y;
    }

    function minus() view external returns(uint) {
        return X - Y;
    }

    function mult() view external returns(uint) {
        return X * Y;
    }

    function div() view external returns(uint) {
        return X / Y;
    }
}