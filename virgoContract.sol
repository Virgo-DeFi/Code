pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";

contract virgoContract { 
    using SafeMath for uint256;
    
    mapping(address => uint256) public balanceUserETH;   
     mapping(address => uint256) public balanceUserBTC;   
      mapping(address => uint256) public balanceUserUNI;  
       mapping(address => uint256) public balanceUserLINK;

    function deposit_ETH(uint256 amount) public payable returns (uint) {
        require(msg.value == amount * uint256(10) ** 18);
        
        // adjust the account's balance
        balanceUserETH[msg.sender] = balanceUserETH[msg.sender].add(amount * uint256(10) ** 18);     
        return balanceUserETH[msg.sender];
    }
    
    // note balanceContract for other tokens incl. BTC, UNI and LINK is future enhancement
    function balanceContractETH() public view returns (uint256) {
        return address(this).balance; 
    }
    
    // updating user balances across ETH, UNI, LINK and BTC
    function updateUserBalance(address buyer, string memory symbol, 
        uint256 amount, string memory incDec) public returns (uint256) {
        if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("BTC")))) {
            if (keccak256(abi.encodePacked((incDec))) == keccak256(abi.encodePacked(("inc")))) {
                return balanceUserBTC[buyer] = balanceUserBTC[buyer].add(amount);
            }
            else {
                 return balanceUserBTC[buyer] = balanceUserBTC[buyer].sub(amount);
            }
        }
        else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("UNI")))) {
            if (keccak256(abi.encodePacked((incDec))) == keccak256(abi.encodePacked(("inc")))) {
                return balanceUserUNI[buyer] = balanceUserUNI[buyer].add(amount);
            }
            else {
                return balanceUserUNI[buyer] = balanceUserUNI[buyer].sub(amount);
            }
        }
        else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("LINK")))) {
            if (keccak256(abi.encodePacked((incDec))) == keccak256(abi.encodePacked(("inc")))) {
                return balanceUserLINK[buyer] = balanceUserLINK[buyer].add(amount);
            }
            else {
                return balanceUserLINK[buyer] = balanceUserLINK[buyer].sub(amount);
            }
        }
        else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("ETH")))) {
            if (keccak256(abi.encodePacked((incDec))) == keccak256(abi.encodePacked(("inc")))) {
                return balanceUserETH[buyer] = balanceUserETH[buyer].add(amount);
            }
            else {
                return balanceUserETH[buyer] = balanceUserETH[buyer].sub(amount);
            }
        }
        else {} // error catching
    }
    
    // function used by buyToken & loanRequest to test sufficient token balance for purchase/collateral
    function getUserBalance(address user, string memory symbol) public view returns (uint256) {
        if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("BTC")))) {
            return balanceUserBTC[user];
        }
        else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("UNI")))) {
            return balanceUserUNI[user];
        }
        else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("LINK")))) {
            return balanceUserLINK[user];
        }
        else if (keccak256(abi.encodePacked((symbol))) == keccak256(abi.encodePacked(("ETH")))) {
            return balanceUserETH[user];
        }
        else {} // error catching
    }
    
    // fallback function
    function () external payable {
    }
}







// UNUSED CODE
// Token BTCtoken = 0x4663FAFe32Ac27aeB1e4bac9b73a1b12E587Dd3B;
    // Token UNItoken = 0x145d5423e9f5194e11138DE68939e46B21374487;
    // Token LINKtoken = 0xBBC14d5aA1005A3E9526bda86F458143A7a01309;
    
    // balances, indexed by addresses
    
// function balanceContractBTC() public view returns (uint256) {
    //     return BTCtoken.balanceOf(address(this));
    // }

    // function balanceContractUNI() public view returns (uint256) {
    //     return UNItoken.balanceOf(address(this));
    // }

    // function balanceContractLINK() public view returns (uint256) {
    //     return LINKtoken.balanceOf(address(this));
    // }
    