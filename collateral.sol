pragma solidity ^0.5.0;

import "./loan.sol";
import "./buyToken.sol";

contract LoanRequest is virgoContract, buyToken {
    using SafeMath for uint256;
    
    // declare virgoContract instance
    virgoContract vc;
    
    address payable borrower = msg.sender;
    address payable vContract; 
    Token token;
    string tokenSymbol;
    uint256 collateralAmount_Token;
    uint256 collateralAmount_WEI;
    uint256 loanAmount_WEI;
    uint256 payoffAmount_WEI;
    uint256 loanDuration;
    uint256 public price; 
    
    constructor(
        address payable _vContract,
        Token _token,
        // note _collateralAmount_Token is denominated in 18 decimals, like Wei
        uint256 _collateralAmount_Token,
        uint256 _loanAmount_WEI,
        uint256 _payoffAmount_WEI,
        uint256 _loanDuration_Days
        )
        buyToken(_vContract)
        public
    {
        vc = virgoContract(_vContract);
        vContract = _vContract; //
        token = _token;
        tokenSymbol = token.symbol();
        collateralAmount_Token = _collateralAmount_Token;
        
        price = uint(getPrice(tokenSymbol));
        
        // convert token collateral amount into WEI
        collateralAmount_WEI = (collateralAmount_Token / (uint256(10) ** 18)).mul(price);
        loanAmount_WEI = _loanAmount_WEI;
        payoffAmount_WEI = _payoffAmount_WEI;
        loanDuration = _loanDuration_Days.mul(24 * 60 * 60);
        
        // LTV threshold test: LTV <= 50%
        require (collateralAmount_WEI >= (loanAmount_WEI * 2), "Implied LTV too high!");
        
        // Verify token account balance high enough for collateral pledge
        require(vc.getUserBalance(msg.sender, tokenSymbol) >= collateralAmount_Token, "You don't have enough token balance for collateral!");
    }
    
    Loan public loan;
    
    event LoanRequestAccepted(address loan);

    function lendEther() public payable {
        require(msg.value == loanAmount_WEI);
        
        // loan contract should technically be between lender and virgoContract but shown here as borrower assuming 
        // personal recourse
        loan = new Loan(
            vContract,
            msg.sender,
            borrower,
            token,
            collateralAmount_Token,
            payoffAmount_WEI,
            loanDuration
        );
        
        // tokens should be held by virgoContract but held here by borrower given allowance constraints
        require(token.transferFrom(borrower, address(loan), collateralAmount_Token));
        
        // ETH proceeds should go to virgoContract with user ETH balance reflecting the increase
        vContract.transfer(loanAmount_WEI); //
        
        // update user balances post-loan issuance
        vc.updateUserBalance(borrower, tokenSymbol, collateralAmount_Token, "dec"); //
        vc.updateUserBalance(borrower, "ETH", loanAmount_WEI, "inc"); //
        
        emit LoanRequestAccepted(address(loan));
    }
}





// UNUSED CODE
// hardcoded token pricing instead of calling getPrice function from buyToken: "Contract code size over limit. 
    // Contract creation initialization returns data with length of more than 24576 bytes." 
    // uint256 priceBTC = 13970731190073906500;
    // uint256 priceUNI = 20752405000000000;
    // uint256 priceLINK = 11350259488093700;
    
    // if (keccak256(abi.encodePacked((tokenSymbol))) == keccak256(abi.encodePacked(("BTC")))) {
        //         price = priceBTC;
        //     }
        //     else if (keccak256(abi.encodePacked((tokenSymbol))) == keccak256(abi.encodePacked(("UNI"))))  {
        //         price = priceUNI;
        //     }
        //     else if (keccak256(abi.encodePacked((tokenSymbol))) == keccak256(abi.encodePacked(("LINK"))))  {
        //         price = priceLINK;
        //     }
        //     else {price = 999;
        //     }
        
        // function balanceETHContract() public view returns (uint) {
    //     return (address(this).balance);
    // }
    
        