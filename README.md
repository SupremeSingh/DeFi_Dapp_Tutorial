**DEFI DAPP TUTORIAL**

**Deployment Network – Ropsten** 

**Roadmap –** 

This is an example of how you can build your own solidity repos as suggested by me in https://tinyurl.com/dblinfo. Build a solidity project that allows the deployer to launch their own token, be able to decide which other tokens they want to trade them against, make trades with those tokens on the latest version of Uniswap and manage their liquidity as well. 

As an application of that token, buyers can use them to enter a lottery out of which they stand to win a large amount of (testnet) ETH. The entry price of award amount can be set by the owner.

**Step 1 – Making your own token** 

Here, we will be building an ERC-20 token based on the boilerplate code provided by OpenZeppelin. 

Learning objectives 

- Building your first instance of web3 primitive 
- Modifying it with real-word constraints 
- Learning to deploy and interact with contract 

Challenge - Mimicking some elements BTC behaviour 

- Should have a capped supply 
- Reward miners for including transactions in block 
- Cannot be minted randomly by other users 

Hints

- Make sure to import your token to MM before proceeding further. 
- Wrap some Ether for trading via Uniswap

Question – What are the pros/cons of using 18 v/s 9 decimals? Note BTC uses 9 decimals whereas ETH uses 18.  

**Step 2 – Enabling trades for this token**

For this tutorial, we have chosen the Uniswap V3 DEX. The idea is to implement *exact input* and *exact output* trades for *single-path* transactions. 

Learning objectives 

- Familiarising user with Uniswap v3 and EtherScan 
- Learning how ERC-20 approval works 
- Become comfortable with wrapped Ether and tokens
- Setting up Liquidity pools 

Challenges –

- Set up a liquidity pool for WETH/<Your token> with 0.3% fee
- Managing positional NFTs and adding/withdrawing liquidity 
- Creating a smart contract for liquidity management 

Hints

- Address for arguments (<https://docs.uniswap.org/protocol/reference/deployments>) 
- Think about WETH/ETH and why Uniswap uses WETH
- You need to approve Uniswap to extract your WETH tokens from your wallet first.

Question – How does Uni V3 store your liquidity data in the NFT it provides you?   


**Step 3 – Controlling trade flow for our token**

Now, we will create a proxy contract that allows the owner of the contract to create a whitelist of acceptable tokens they will sell against and also set an entry fee for participants to join the lottery. 

Learning objectives 

- Learning to use proxies as a design principle in solidity 
- Building contracts that hold assets like Eth actively 
- Getting comfortable with signing transactions programmatically 

Challenges –

- The contract should be able to transact with Uniswap without needing user approval every time
- Users should be able to get the most out of their investment from our liquidity pool 
- If removed from the whitelist, your contract should not be able to spend that token anymore

Hints

- How will the contract pay the gas fees for making the swaps?
- What do you need to do to return the investor’s money back to them in full ?

Question – Does this provide any special privileges to whoever got the initial mint of your token   

**Step 4 – Making the Lottery Contract**

Finally, we will make a lottery contract that requires the user to buy in with our token. Once the player has been added, we will use Chainlink VRF to generate a random winner and then unload the contract’s Eth balance on them. 

Learning objectives 

- Making a more complex smart contract all by yourself 
- Using oracles to get off chain data 
- Using data structues like structs and enums properly 
- Checking for security vulnerabilities in contracts 

Challenges –

- How will you implement verifiable randomness in the system?
- Can you find a re-entrancy attack in this contract?

Hints

- How can you succinctly represent the states of the lottery? 
- Can a new lottery start as soon as this one ends without making any changes to our state variables?
- Use Link tokens and other useful primitives - <https://docs.chain.link/docs/vrf-contracts/#rinkeby-testnet> 

Question – What makes our random number verifiably random?   

**Step 5 – Deploying Contracts and Verifying**

To make our contracts interactable, we will be deploying them to the Rinkeby testnet and then going through the verification process. Verification will allow us to call these contracts at their deployed addresses elsewhere in the project, as well as when we build out a corresponding front-end with *create-eth-app*

Learning objectives 

- Learning the fundamentals of JS 
- Deployments, web3 basics and important libraries
- Importance of an indexer for a blockchain 

Challenges –

- Making sure approvals between contracts are made sequentially 
- Integrating deployed contracts with other scripts and tests

Hints –

- Library we will be using is <https://github.com/wighawag/hardhat-deploy> 

**Step 5 – Deploying Contracts and Verifying**

To test our contracts, we will now use Waffle, Chain (popular JS testing frameworks) and Ethers.js to write unit tests for this contract. 

Learning objectives 

- Testing as a prerequisite to sending anything to the mainnet 

Challenges –

- Using Waffle Fixtures at a later stage of this project 
- Writing integrated tests for interactions between the contracts 

Hints –

- Should we be deploying the entire code everytime we test? 
- The lottery contract will break if the vendor or swapper do not work. How?
- Docs on testing … <https://hardhat.org/tutorial/testing-contracts.html> 
- Debugging tool … <https://dashboard.tenderly.co/> 
