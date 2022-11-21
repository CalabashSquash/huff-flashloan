pragma solidity >=0.8.0;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialAmount
    ) ERC20(_name, _symbol, _decimals) {
        _mint(msg.sender, _initialAmount);
    }
}
