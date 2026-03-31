// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract InsurancePool is Ownable, ReentrancyGuard {
    struct Policy {
        address holder;
        uint256 coverageAmount;
        uint256 expiration;
        bool claimed;
        bool active;
    }

    IERC20 public immutable poolToken;
    uint256 public totalLiquidity;
    mapping(address => uint256) public underwriterBalances;
    mapping(uint256 => Policy) public policies;
    uint256 public nextPolicyId;

    event LiquidityAdded(address indexed provider, uint256 amount);
    event PolicyPurchased(uint256 indexed policyId, address indexed holder, uint256 amount);
    event ClaimPaid(uint256 indexed policyId, address indexed receiver, uint256 amount);

    constructor(address _token) Ownable(msg.sender) {
        poolToken = IERC20(_token);
    }

    function provideLiquidity(uint256 _amount) external nonReentrant {
        poolToken.transferFrom(msg.sender, address(this), _amount);
        underwriterBalances[msg.sender] += _amount;
        totalLiquidity += _amount;
        emit LiquidityAdded(msg.sender, _amount);
    }

    function buyPolicy(uint256 _coverageAmount, uint256 _duration) external {
        uint256 premium = (_coverageAmount * 5) / 100; // Flat 5% premium for simplicity
        require(totalLiquidity >= _coverageAmount, "Insufficient pool liquidity");
        
        poolToken.transferFrom(msg.sender, address(this), premium);
        
        policies[nextPolicyId] = Policy({
            holder: msg.sender,
            coverageAmount: _coverageAmount,
            expiration: block.timestamp + _duration,
            claimed: false,
            active: true
        });

        emit PolicyPurchased(nextPolicyId++, msg.sender, _coverageAmount);
    }

    function payoutClaim(uint256 _policyId) external onlyOwner nonReentrant {
        Policy storage policy = policies[_policyId];
        require(policy.active && !policy.claimed, "Invalid policy state");
        require(block.timestamp <= policy.expiration, "Policy expired");

        policy.claimed = true;
        policy.active = false;
        totalLiquidity -= policy.coverageAmount;
        
        poolToken.transfer(policy.holder, policy.coverageAmount);
        emit ClaimPaid(_policyId, policy.holder, policy.coverageAmount);
    }
}
