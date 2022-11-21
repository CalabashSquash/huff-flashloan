// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import {MockERC20} from "src/mock/MockERC20.sol";

contract FlashloanTest is Test {
    /// @dev Address of the SimpleStore contract.
    Flashloan public flashloan;

    /// @dev Setup the testing environment.
    function setUp() public {
        // flashloan = Flashloan(HuffDeployer.deploy("Flashloan"));
        flashloan = Flashloan(
            HuffDeployer.deploy_with_args(
                "Flashloan",
                abi.encodePacked(address(this))
            )
        );
    }

    function testOwnerSet() public {
        assertEq(flashloan.getOwner(), address(this));
        flashloan.setOwner(address(123));
        assertEq(flashloan.getOwner(), address(123));
    }

    /// @dev Ensure that you can set and get the value.
    function testSetAndGetPermed(address usr) public {
        vm.assume(usr != address(0));
        flashloan.setPermed(usr);
        assertEq(flashloan.getPermed(usr), 1);
    }

    /// @dev Ensure that you perms aren't set automatically
    function testPermedNotAutomaticallySet(address usr) public {
        assertEq(0, flashloan.getPermed(usr));
    }

    function testDeposit(uint256 amount) public {
        MockERC20 token = new MockERC20("Test", "TST", 18, amount);
        token.approve(address(flashloan), amount);
        flashloan.deposit(address(token), amount);
        uint256 deposited = flashloan.getDeposited(
            address(this),
            address(token)
        );
        uint256 balance = token.balanceOf(address(flashloan));
        assertEq(deposited, amount);
        assertEq(balance, amount);
    }
}

interface Flashloan {
    function getPermed(address) external returns (uint256);

    function setPermed(address) external;

    function getOwner() external returns (address);

    function setOwner(address) external;

    function deposit(address, uint256) external;

    function getDeposited(address, address) external returns (uint256);
}
