// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    uint256 number = 1;
    FundMe fundme;

    function setUp() external {
        DeployFundMe dfundme = new DeployFundMe();
        fundme = dfundme.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMessageSender() public {
        assertEq(fundme.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public {
        assertEq(fundme.getVersion(), 4);
    }
}
