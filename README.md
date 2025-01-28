# Privacy in Swarm Robotics: Secure Identity verification and Anonymous Voting

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://github.com/LocalBack/Identity_Voting/actions/workflows/ci.yml/badge.svg)](https://github.com/LocalBack/Identity_Voting/actions)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/LocalBack/Identity_Voting/pulls)


---

## 📋 Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Contract Overview](#contract-overview)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contact](#contact)


## 🌟 Features
- Identity management via `IdentityManager.sol`.
- Anonymous voting via `AnonymousVoting.sol`.
- Truffle framework integration.
  
## 🚀 Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/LocalBack/Identity_Voting.git
   cd Identity_Voting

2. Install Dependencies
   "npm"
   "@openzeppelin/contracts": "^4.9.3"
   "@truffle/hdwallet-provider": "^2.1.15"
   "dotenv": "^16.3.1"
   "truffle-flattener": "^1.6.0"
   "truffle-plugin-verify": "^0.6.7"
   "node": ">=18.0.0"
   "web3": "1.10.0"

## 🛠 Contract Overview
   ### IdentityManager.sol
   Manages user identity registration/verification.

   ### AnonymousVoting.sol
   Handles vote submission and tallying.

## 🧪 Testing
1. Run tests with Truffle:
   
truffle test


## 🌐 Deployment
1. Compile contracts:

truffle compile

2. Deploy to Sepolia testnet:

truffle migrate --network sepolia

## 📧 Contact
For questions or feedback, email [mkahya0301@gmail.com]
