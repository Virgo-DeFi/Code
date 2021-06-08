pragma solidity ^0.5.0;

import "./loanToken.sol";
import "./virgoContract.sol";

contract Loan is virgoContract { 
    using SafeMath for uint256;

    // declare virgoContract instance
    virgoContract vc; 
    
    address payable lender;
    address payable borrower;
    Token public token;
    uint256 public collateralAmount;
    uint256 public payoffAmount;
    uint256 public dueDate;
    // uint256 public balanceETHLoan = address(this).balance;
    uint public fakenow = now;

    constructor(
        address payable _vContract,
        address payable _lender,
        address payable _borrower,
        Token _token,
        uint256 _collateralAmount,
        uint256 _payoffAmount,
        uint256 loanDuration
    )
        public
    {
        vc = virgoContract(_vContract); 
        lender = _lender;
        borrower = _borrower;
        token = _token;
        collateralAmount = _collateralAmount;
        payoffAmount = _payoffAmount;
        dueDate = now.add(loanDuration); 
    }

    event LoanPaid();
    
    function payLoan() public payable {
        require(fakenow <= dueDate);
        require(msg.value == payoffAmount);

        require(token.transfer(borrower, collateralAmount));
        emit LoanPaid();
        selfdestruct(lender);
        
        // update user token/ETH balances at virgoContract
        vc.updateUserBalance(msg.sender, token.symbol(), collateralAmount, "inc"); 
        vc.updateUserBalance(msg.sender, "ETH", msg.value, "dec"); 
    }

    function repossess() public {
        require(fakenow > dueDate);

        require(token.transfer(lender, collateralAmount));
        selfdestruct(lender);
    }
    
    function fastforward() public {
        fakenow = fakenow.add(400 days); 
    }
}