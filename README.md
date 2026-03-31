# Decentralized Insurance Pool

A professional-grade framework for on-chain risk management. This repository provides a secure way for "Underwriters" to provide liquidity to a pool and "Policyholders" to purchase coverage against specific smart contract failures or de-pegging events.

## Core Features
* **Capital Efficiency:** Pooled liquidity for maximum coverage capacity.
* **Premium Engine:** Calculates costs based on the risk parameters and duration.
* **Claims Governance:** Integrated voting/multi-sig mechanism for validating payout requests.
* **Flat Architecture:** Single-directory logic for rapid deployment and transparency.

## Workflow
1. **Stake:** Underwriters deposit stablecoins into the pool to earn premiums.
2. **Purchase:** Users buy a policy by paying a premium to the pool.
3. **Claim:** If an event occurs, a claim is submitted.
4. **Payout:** After validation, funds are automatically released to the policyholder.

## Setup
1. `npm install`
2. Deploy `InsurancePool.sol`.
3. Use `manage-claims.js` to simulate the assessment and payout flow.
