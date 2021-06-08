pragma solidity ^0.5.0;

/**pragma solidity >=0.4.22 <0.8.0;
 * import "https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMathQuad.sol";
*/

import "@chainlink/contracts/src/v0.5/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {

    AggregatorV3Interface internal BTCETHpriceFeed;
    AggregatorV3Interface internal UNIETHpriceFeed;
    AggregatorV3Interface internal LINKETHpriceFeed;

    /**
     * Network: Kovan
     * Aggregator: COIN/USD
     * ETH/USD: 0x9326BFA02ADD2366b30bacB125260Af641031331
     * BTC/USD: 0x6135b13325bfC4B00278B4abC5e20bbce2D6580e
     * UNI/USD: 0xDA5904BdBfB4EF12a3955aEcA103F51dc87c7C39
     * LINK/USD: 0x396c5E36DD0a0F5a5D33dae44368D4193f69a1F0
     
     * Aggregator: COIN/ETH
     * BTC/ETH: 0xF7904a295A029a3aBDFFB6F12755974a958C7C25
     * UNI/ETH: 0x17756515f112429471F86f98D5052aCB6C47f6ee
     * LINK/ETH: 0x3Af8C569ab77af5230596Acf0E8c2F9351d24C38
     */

    constructor() public {
        BTCETHpriceFeed = AggregatorV3Interface(0xF7904a295A029a3aBDFFB6F12755974a958C7C25);
        UNIETHpriceFeed = AggregatorV3Interface(0x17756515f112429471F86f98D5052aCB6C47f6ee);
        LINKETHpriceFeed = AggregatorV3Interface(0x3Af8C569ab77af5230596Acf0E8c2F9351d24C38);
    }

    /**
     * Returns the latest price
     */
    function getBTC_ETH_Price() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = BTCETHpriceFeed.latestRoundData();
        return price;
    }
    
    function getUNI_ETH_Price() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = UNIETHpriceFeed.latestRoundData();
        return price;
    }
    
    function getLINK_ETH_Price() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = LINKETHpriceFeed.latestRoundData();
        return price;
    }
}