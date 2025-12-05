# Smart Contract Test Report: MyToken (MTK)

**Date:** December 05, 2025  
**Environment:** Remix IDE (In-browser VM)  
**Compiler Version:** Solidity 0.8.30  
**Contract Name:** MyToken  
**Symbol:** MTK  

---

## 1. Executive Summary
This document details the functional and negative testing of the `MyToken` ERC-20 smart contract. The tests were conducted using the Remix IDE JavaScript VM. The testing scope covers compilation, deployment, metadata verification, direct transfers, and the approval/delegated transfer mechanism (`transferFrom`). All core ERC-20 functionalities behaved as expected, with appropriate revert messages for invalid operations.

---

## 2. Compilation & Deployment

### 2.1 Compilation
* **Status:** Success
* **Compiler:** Solidity 0.8.30+commit.73712a01
* **Optimization:** Disabled (default)
* **Observation:** The contract compiled without errors or warnings.

### 2.2 Deployment
* **Deployer Account:** `0x5B3...eddC4`
* **Gas Used:** Estimated ~3,000,000 gas limit (transaction successful).
* **Deployed Address:** `0xd9145CCE52D386f254917e481eB44e9943F39138`
* **Initial Supply Input:** `10000000000000000000000` (10,000 Tokens with 18 decimals)

---

## 3. State Variable Verification (Metadata)
Post-deployment, the standard ERC-20 public variables were queried to ensure correct initialization.

| Variable | Expected Value | Actual Value | Status |
| :--- | :--- | :--- | :--- |
| **Name** | `MyToken` | `MyToken` | ✅ PASS |
| **Symbol** | `MTK` | `MTK` | ✅ PASS |
| **Decimals** | `18` | `18` | ✅ PASS |
| **Total Supply** | `10000...000` | `10000...000` | ✅ PASS |
| **BalanceOf (Deployer)** | `10000...000` | `10000...000` | ✅ PASS |

---

## 4. Functional Testing: Direct Transfers

### 4.1 Valid Transfer
**Scenario:** Transfer tokens from Deployer to a User.
* **Sender:** `0x5B3...eddC4`
* **Recipient:** `0xAb8...35cb2`
* **Amount:** `100` tokens (expressed in wei)
* **Result:** Transaction successful.
* **Logs:** 1 log generated (`Transfer` event emitted).

### 4.2 Invalid Transfer: Zero Address
**Scenario:** Attempting to transfer tokens to the `0x000...000` address.
* **Input:** `_to: 0x0000000000000000000000000000000000000000`
* **Result:** Transaction Reverted.
* **Error Message:**
    > "Cannot transfer to zero address"
* **Status:** ✅ PASS (Safety check functioning).

---

## 5. Functional Testing: Approvals & Delegated Transfers

### 5.1 Invalid TransferFrom (Insufficient Allowance)
**Scenario:** Third party attempts to spend tokens from a holder without prior approval.
* **Spender:** `0xAb8...35cb2`
* **Owner:** `0x5B3...eddC4`
* **Action:** Call `transferFrom`
* **Result:** Transaction Reverted.
* **Error Message:**
    > "Insufficient allowance"
* **Status:** ✅ PASS (Security check functioning).

### 5.2 Invalid TransferFrom (Insufficient Balance)
**Scenario:** Attempting to transfer more tokens than the account holds, even if logic permits entry.
* **Result:** Transaction Reverted.
* **Error Message:**
    > "Insufficient balance"
* **Status:** ✅ PASS.

### 5.3 Valid Approval & TransferFrom
**Scenario:** Owner approves Spender, Spender transfers tokens on Owner's behalf.

**Step A: Approve**
* **Caller:** Owner (`0x5B3...`)
* **Spender:** `0xAb8...`
* **Value:** `50000...000`
* **Result:** Transaction Mined. `Approval` event implicit.

**Step B: TransferFrom**
* **Caller:** Spender (`0xAb8...`)
* **From:** Owner (`0x5B3...`)
* **To:** Recipient (`0x4B2...`)
* **Value:** `50000...000`
* **Result:** Transaction successful.
* **Logs:** `Transfer` event emitted correctly.
* **Status:** ✅ PASS.

---

## 6. Event Logging
The contract correctly emits events which are critical for off-chain indexing (dApps).

* **Transfer Event:** Emitted upon successful `transfer` and `transferFrom`.
    * Fields verified: `_from`, `_to`, `_value`.
* **Execution Cost:** Helper functions like `getTokenInfo` and standard writes consumed gas within expected EVM limits.

## 7. Conclusion
The `MyToken` smart contract successfully passed all unit tests conducted in the Remix IDE.
1.  **Deployment** works correctly with dynamic initial supply.
2.  **Transfers** correctly update balances.
3.  **Safety Checks** (Zero address, insufficient balance) are active and reverting with clear strings.
4.  **Allowances** (ERC-20 Standard) are strictly enforced.

**Recommendation:** The contract is functionally sound based on this test suite.
