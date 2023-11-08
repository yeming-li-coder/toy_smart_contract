// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Script, console2} from "forge-std/Script.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackGasLimit;
    }

    NetworkConfig public activateNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activateNetworkConfig = getSepoliaEthConfig();
        } else {
            activateNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activateNetworkConfig.vrfCoordinator != address(0)) {
            return activateNetworkConfig;
        }

        uint96 baseFee = 0.25 ether;
        uint96 gasPriceLink = 1 gwei;

        vm.startBroadcast();
        VRFCoordinatorV2Mock vrfCoordinatorMock = new VRFCoordinatorV2Mock(
            baseFee,
            gasPriceLink
        );
        vm.stopBroadcast();

        return NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: address(vrfCoordinatorMock),
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            subscriptionId: 0,
            callbackGasLimit: 500000
        });
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            subscriptionId: 0,
            callbackGasLimit: 500000
        });
    }
}
