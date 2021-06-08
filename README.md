<p align="center"><img width=100% src="Images/columbia_engineering.png"></p>

<p align="center" style="color:DodgerBlue; font-family:cambria; font-variant: normal; font-size:1000pt">Columbia | FinTech
</p>

# Project 3: virgoDeFi in Solidity

![contract](Images/Virgo.jpg)

# Overview

The project aims to build a DeFi application where users can purchase and manage crypto and use their tokens as collaterals for loans.
The application is built using smart contracts on Solidity. Users can deposit Ethereum into the contract and can initiate a process to book a loan against his/her deposit,
the user can borrow ETH against Crypto holdings subject to a 50% LTV threshold.

# Introduction

The breakout of the cryptocurrency and blockchain markets during the last decade created one of the most disruptive forces in 
the global financial markets.

The concept of tokenization is now being applied across different industries in what blockchain enthusiasts are calling the
decentralization of the financial markets. This allows investors to use different crypto assets as collateral for loans.
Crypto investors can now access cash tied to their crypto assets without necessarily selling their cryptocurrencies.

Short for decentralized finance, DeFi is an umbrella term for financial services offered on public blockchains. 
Like traditional banks, DeFi applications allow users to borrow, lend, earn interest, and trade assets and derivatives, 
among other things. The collection of services is often used by people seeking to borrow against their crypto holdings to 
place even larger bets.

<details><summary>  <b> ENVIRONMENTAL PREREQUISITES </b></summary>
THe following are tools used for the projects: 

* [Remix IDE](https://remix.ethereum.org) to create the contract using Solidity programming Language.

* [Ganache](https://www.trufflesuite.com/ganache) a Development blockchain with prefunded account addresses which can be uused for testing purposes. 

* [MetaMask](https://metamask.io) a Crypto wallet and gateway to blockchain apps. Download the metamask Browser extension and pin it to your favorite browser and point it to the localhost:8545 by createting a 'testnet' chain, or replace the port with what you have set in your workspace.
</details>

# Design

<details><summary>  <b> Design </b></summary>

The Project integrates 6 smart contracts that combine to provide full customer functionality.

Virgo Contract ==> Oracle ==> Buy Token ==> Loan Token ==> Collateral ==> Loan​
</details>

# Virgo Contract
<details><summary>  <b> Virgo Contract </b></summary>

[`virgoContract.sol`](virgoContract.sol) -- virgo contract creates the Crypto Portfolio and Token Specific Account Tracking​. It achieves the following:

•	Allow users to deposit ether

•	Map the sender address to their respective coin balance

•	With the contract, we can update the users’ coin balances with the equivalent token and

•	Finally the contract reduces the ether balance with the amount of token purchased

</details>

# Buy Token Contract

<details><summary>  <b> Buy Token </b></summary>

[`Oracle.sol`](Oracle.sol) ---This contract contains real-time pricing feeds.

[`buyToken.sol`](buyToken.sol) -- This contract calls Oracle.sol when the user is buying the token and uses the pricing from the Oracle.sol contract to determine the number of token the user can buy.

It achieves the following:

•	Import real-time market prices using Kovan Network

•	Tests sufficient account balance

•	Buy Tokens based on user’s token Symbol (e.g. BTC, UNI or LINK) along with the ETH Buy Amount

•	Use ERC-20 to mint tokens via [`loanToken.sol`](loanToken.sol)
	
•	Calculates no of Tokens to be minted by dividing ETH BuyAmount / TokenPrice


</details>

# Loan Token Contract

<details><summary>  <b> Loan Token​ </b></summary>

[`loanToken.sol`](loanToken.sol) ---This contract achieves the following :

•	Issues Fungible Tokens following ERC20 and ERC20Mintable standards 

•	Token minted: Bitcoin, Uniswap, LINK 

•	Token approves address spending allowances to support ‘transferFrom’ functionality

</details>

# Collateral Contract

<details><summary>  <b> Collateral​ </b></summary>

[`collateral.sol`](collateral.sol) ---This contract achieves the following :

•	Creates loan request object based on user's token collateral, collateral amount, loan amount, payoff amount and duration

•	Loan object imported from [`loan.sol`](loan.sol)

•	Provides function for a lender to accept loan request and transfer ETH
</details>

# Loan Contract

<details><summary>  <b> Loan​ Contract </b></summary>

[`loan.sol`](loan.sol) ---This contract achieves the following :

•	Creates Loan Object with attributes: <br/>
		1.Borrower <br/>
		2.Lender <br/>
		3.Collateral amount <br/>
		4.Loan amount <br/>
		5.Payoff amount <br/>
		6.Loan Duration <br/>

•	Pay Loan: Repay the ETH payoff amount and transfer token collateral back to borrower

•	Repossess Loan: Overdue Loan closed and transfer token collateral to Lender

</details>

# Process workflow

<details><summary>  <b> Workflow </b></summary>

![Workflow](Images/Workflow.png)
	
Below is a practical walk-through of the steps involved to create a virgoDeFi account and borrow ETH.

## Before You Start <br/>
• Open Solidity files in Remix <br/>
	
• Switch to local network <br/>
	
• Set `msg.sender` to your account <br/>

## Opening Your Account <br/>
• [`virgoContract.sol`](virgoContract.sol) allows you to open token accounts and track your balances <br/>
	
• First compile and deploy [`virgoContract.sol`](virgoContract.sol) <br/>
	
• To deposit ETH: set `msg.value` to deposit amount, click `Deposit` button and enter ETH deposit amount <br/>

• ETH deposit will be transferred to [`virgoContract.sol`](virgoContract.sol)

• Check `userBalanceETH`, `userBalanceBTC`, and `balanceContract` <br/>

## Buying Tokens <br/>
• Compile and deploy [`buyToken.sol`](buyToken.sol) providing the [`virgoContract.sol`](virgoContract.sol) address <br/>
	
• For live prices, switch to Kovan testnet with an account containing sufficient ETH balance <br/>
	
• Compile/Deploy [`buyToken.sol`](buyToken.sol) <br/>
	
• Go to `GetLivePrice` and enter `BTC`, `UNI` or `LINK` to get live prices <br/>
	
• Note that prices are quoted in Wei <br/>
	
• To actually buy tokens switch back to Local network with appropriate account <br/>
	
• Redeploy [`buyToken.sol`](buyToken.sol) <br/>
	
• Click `buyTokens` and enter token symbol (`BTC`, `UNI` or `LINK`) and buy amount in `ETH`, then transact. New tokens will be minted and automatically transfer to  [`virgoContract.sol`](virgoContract.sol). User balances will also update. <br/>
	
• In case of insufficient `ETH` balance, transaction will be rejected <br/>
	
• Check `noTokens` to see the number of tokens for the `ETH` purchase amount based on the token price <br/>
	
• Go back to [`virgoContract.sol`](virgoContract.sol) and check the relevant balanceUser (eg `balanceUserBTC` for BTC purchase) and `balanceUserETH` which should show reduced `ETH` balance to reflect purchase <br/>
	
• At [`buyToken.sol`](buyToken.sol) click `token` to copy new token address. Change `CONTRACT` to `Token` and enter the token address `At Address`. Then open the new `token` appearing at the bottom <br/>
	
• Check user’s `balanceOf` which should reflect purchased tokens <br/>
	
• Check `allowance` (owner = buyToken, spender = user) which should be 0 <br/>
	
• Repeat process for other tokens. Note that in this version each purchase results in a new token mint, ie repeat token purchases are minted separately <br/>

## Borrowing Against Crypto <br/>
• Set `msg.sender` to borrower <br/>
	
• Compile [`collateral`](collateral.com) then deploy `loanRequest` providing [`virgoContract.sol`](virgoContract.sol), [`token`](token.sol) addresses and relevant loan parameters (all in 18 decimals units, like `Wei`) <br/>
	
• `loanRequest` verifies that the implied LTV <= 50% and that user (`msg.sender`) has sufficient token balance to support the collateral amount <br/>
	
• If successful, a new `loanRequest` object is created in the lefthand column <br/>
	
• Before the `loanRequest` can be accepted, the user needs to approve the new `loanRequest` contract’s ability to transfer the borrower’s tokens as collateral to a new loan contract:<br/>
	
• Open [`token`](token.sol) in lefthand column and click `Approve` entering the following details <br/>
  `Spender` = `loanRequest` contract address <br/>
  `Amount` =  collateral amount of `loanRequest` <br/>
	
• Confirm the approval of the collateral amount by verifying `Allowance`: <br/>
  `Owner` = user <br/>
  `Spender` = `loanRequest` contract <br/>
	
• To accept the `loanRequest`, change `msg.sender` to the `lender` address <br/>
	
• Then re-open `loanRequest` <br/>
	
• Check `At Address` field is empty <br/>
	
• Enter `msg.value` = requested loan amount and click `LendEther` button of `loanRequest` to accept and issue the loan <br/>
	
• Upon successful completion, collateral tokens will be transferred from borrower to the new loan contract, the `Lender`’s ETH balance will be reduced by loan amount which is transferred to [`virgoContract`](virgoContract.sol) while the borrower’s token and ETH balances are updated (can be verified via the balance functions of [`virgoContract`](virgoContract.sol) <br/>

## Repaying/Repossessing The Loan <br/>
• Open the new [`loan`](loan.sol) object by copying the `loan` object address under `loanRequest`, change `CONTRACT` field to `Loan`, and entering the `loan` object address in `At Address`. The `loan` object will appear in the lefthand column <br/>
	
• The loan can be repaid anytime before the due date. Check `Fakenow` for current time and check `dueDate`. `fastforward` shifts 400 days forward. <br/>
	
• To repay the loan, set `msg.sender` to the borrower (though technically anyone can repay the loan). Set `msg.value` to loan `payoffamount` amount and click `payLoan` <br/>
	
• Borrower will transfer `ETH` payoff amount to the `loan` contract which via `selfdestruct` will transfer ETH back to the Lender <br/>
	
• The borrower will receive the token collateral back, and a reduced ETH balance to reflect loan payment, both reflected in [`virgoContract`](virgoContract.sol) user balances <br/>
	
• Loans that are not repaid before the due date are subject to repossession whereby token collateral is transferred from loan contract to the lender <br/>
	
• To test this, due to `selfdestruct`, we need to first re-issue another loan on same terms: <br/>
	
• Set `msg.sender` to Lender <br/>
	
• Open existing 'loanRequest` <br/>
	
• Check `At Address` empty <br/>
	
• Set `msg.value` to loan amount and click `LendEther` <br/>
	
• Open the new [`loan`] object by copying the `loan` object address under `loanRequest`c<br/>
	
• Change `CONTRACT` field to `Loan` <br/>
	
• Enter new `loan` address (in `loanRequest`) in `At Address` field, loan contract appears in left hand column <br/>
	
• set `msgSender` to Lender <br/>
	
• Check `Fakenow` & `dueDate` <br/>
	
• `FAST FORWARD` past `dueDate` <br/>
	
• click `repossess`. Lender token balance under `Token` should now reflect the collateral as balance <br/>


</details>

# Future Enhancements
<details><summary>  <b> Future Enhancements </b></summary>

## Current Code <br/>

•	Enhanced error catching

•	Enhanced security (Reentrancy etc)

•	virgoContract general ledger balances for all tokens

•	no re-minting for repeat token purchases


## Features beyond current code <br/>

•	User Interface (UI)
	
•	Crypto sales

•	Enhanced loan functionality incl. periodic interest payments, LTV liquidation triggers
	
•	Integrate with liquidity provider, eg ETH-wrapped Crypto
	
•	Crypto lending 
	
•	Crypto staking

•	Option to transact in Fiat Currency
	
•	Expand Crypto Range​

</details>

# Resources ---link to video

 [Video Demo Link](https://1drv.ms/p/s!Aola6McPYvrQnxL7-1Lv4MUn2mCj)

