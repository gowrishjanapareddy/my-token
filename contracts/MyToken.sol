// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    // --- 1. Token Metadata ---
    // These variables define the identity of your token.
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // --- 2. Balances ( The Ledger ) ---
    // A mapping acts like a database lookup.
    // Key (Address) -> Value (Balance)
    mapping(address => uint256) public balanceOf;

    // --- 3. Allowances ( Permissions ) ---
    // A nested mapping to track who is allowed to spend your tokens.
    // Owner -> Spender -> Amount
    mapping(address => mapping(address => uint256)) public allowance;

    // --- 4. EVENTS ---
    // Events allow external applications (like wallets) to listen for changes.
    
    // Emitted when tokens move from one wallet to another
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    // Emitted when a user approves another wallet to spend their tokens
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // --- 5. Constructor ---
    // This runs automatically ONCE when the contract is deployed.
    constructor(uint256 _initialSupply) {
        // 1. Set the total supply variable
        totalSupply = _initialSupply;
        
        // 2. Assign the ENTIRE supply to the wallet deploying the contract (you)
        balanceOf[msg.sender] = _initialSupply;
    }

    // --- 6. TRANSFER FUNCTION ---
    // Moves tokens from the caller's wallet to another address.
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // 1. Safety Check: Prevent burning tokens to the zero address
        require(_to != address(0), "Cannot transfer to zero address");
        
        // 2. Safety Check: Ensure sender has enough tokens
        // msg.sender is the person clicking the button
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        // 3. Update State: Subtract from sender, Add to recipient
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // 4. Emit Event: Notify the network
        emit Transfer(msg.sender, _to, _value);

        // 5. Return Success
        return true;
    }

    // --- 7. APPROVE FUNCTION ---
    // Sets how many tokens a spender is allowed to use from your wallet.
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Cannot approve zero address");

        // Set the allowance amount
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // --- 8. TRANSFER FROM FUNCTION ---
    // Allows a spender to transfer tokens from an owner to a recipient.
    // This is used when a smart contract needs to pull tokens from your wallet.
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Cannot transfer to zero address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");

        // 1. Update Balances
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        // 2. Decrease Allowance
        // The spender just used up some of their permission, so we subtract it.
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    // --- 9. HELPER FUNCTIONS ---
    
    // Returns the total number of tokens in existence
    // (This is redundant because 'totalSupply' is public, but good for learning)
    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    // Returns all token details in a single call
    // Useful for websites to load data quickly without making 4 separate calls
    fun
