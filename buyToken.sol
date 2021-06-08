pragma solidity ^0.5.0;

import "./loanToken.sol";
import "./Oracle.sol";
import "./virgoContract.sol";

contract buyToken is PriceConsumerV3, virgoContract {
        using SafeMath for uint256;
        
        Token public token;
        uint256 public noTokens;
        // declare virgoContract instance
        virgoContract vc;
        
        // hardcoding prices since live prices requires Kovan test network with limited ETH balances
        uint256 priceBTC = 13970731190073906500;
        uint256 priceUNI = 20752405000000000;
        uint256 priceLINK = 11350259488093700;

        // assign existing virgoContract address
        constructor (address payable _vContract) public {
            vc = virgoContract(_vContract);
        }
        
        // this function only works on Kovan testnet
        function getLivePrice(string memory symbol) public view returns(int) {
            int coinPrice;
            if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("BTC")))) {
                coinPrice = getBTC_ETH_Price();
            }
            else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("UNI"))))  {
                coinPrice = getUNI_ETH_Price();
            }
            else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("LINK"))))  {
                coinPrice = getLINK_ETH_Price();
            }
            else {coinPrice = 999;
            }
            return coinPrice;
        }
        
        function getPrice(string memory symbol) public view returns(uint256) {
            uint256 coinPrice;
            if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("BTC")))) {
                coinPrice = priceBTC;
            }
            else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("UNI"))))  {
                coinPrice = priceUNI;
            }
            else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("LINK"))))  {
                coinPrice = priceLINK;
            }
            else {coinPrice = 999;
            }
            return coinPrice;
        }
        
        function buyTokens(string memory symbol, uint256 Buy_Amount_in_ETH) public {
            uint256 Buy_Amount_in_Wei = Buy_Amount_in_ETH.mul(uint256(10) ** 18);
            
            require(vc.getUserBalance(msg.sender, "ETH") >= Buy_Amount_in_Wei, "You don't have enough ETH balance!");
            
            noTokens = (Buy_Amount_in_Wei.div(uint(getPrice(symbol)))).mul(uint256(10) ** 18);
        
            // newly minted tokens will be sent to buyToken contract and normally need to be transferred to virgoContract
            // where all token balances reside. However we will transfer them directly to the borrower
            token = new Token(findName(symbol), symbol, noTokens);
            token.approve(address(this), noTokens);
            token.transferFrom(address(this), msg.sender, noTokens);
        
            //update user's token balance on virgoContract
            vc.updateUserBalance(msg.sender, symbol, noTokens, "inc");
            
            // since user already deposited ETH at virgoContract, ETH will not be transferred from user account
            // but simply deducted from user's ETH balance on virgoContract
            vc.updateUserBalance(msg.sender, "ETH", Buy_Amount_in_ETH.mul(uint256(10) ** 18), "dec");
        }
    
        function findName(string memory symbol) internal returns(string memory) {
            string memory name;
            if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("BTC")))) {
                name = "Bitcoin";
            }
            else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("UNI")))) {
                name = "Uniswap";
            }
            else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("LINK")))) {
                name = "LINK";
            }
            else {name = "Unknown"; // error catching
            }
            return name;
        }
}









// UNUSED CODE
// function buyTokens(string memory symbol, uint Buy_Amount_in_ETH) public {
//             // require msg.value == Buy_Amount_in_Wei ADD Min balance test
//             // require (Buy_Amount_in_ETH * uint256(10) ** 18 < balanceUserETH[user]); // ADD Min balance test
//             noTokens = (Buy_Amount_in_ETH * uint256(10) ** 18) / uint(getPrice(symbol));
         
//             // if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("BTC")))) {
//             //     BTCtoken.transferFrom(liquidityProvider, virgoAccount, noTokens);
//             //     // msg.sender.transfer(loanAmount); FIX THIS
//             // }
//             // else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("UNI")))) {
//             //     UNItoken.transferFrom(liquidityProvider, virgoAccount, noTokens);
//             // }
//             // else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("LINK")))) {
//             //     LINKtoken.transferFrom(liquidityProvider, virgoAccount, noTokens);
//             // }
//             // else {} // error catching
            
//             updateUserTokenBalance(msg.sender, symbol, noTokens);
//             updateUserETHBalance(msg.sender, Buy_Amount_in_ETH * uint256(10) ** 18);
            
//             // emit????
//         }


// function transferTokens () public {
        //     // transfer tokens of mint token recipient (address(this)) to virgoContract general ledger
        //     transferFrom(address(this), virgoContract, noTokens);
        // }
        
// address BTCtoken = 0x4663FAFe32Ac27aeB1e4bac9b73a1b12E587Dd3B;
// address UNItoken = 0x145d5423e9f5194e11138DE68939e46B21374487;
// address LINKtoken = 0xBBC14d5aA1005A3E9526bda86F458143A7a01309;
// address payable public liquidityProvider = 0x8cD2270eFaAd0fa381ecb9A85ab4138a3eC08806;

// ETH amount is transferred from virgoContract to liquidityProvider
            // vc.liquidityProvider.transfer(Buy_Amount_in_Wei);
            

        