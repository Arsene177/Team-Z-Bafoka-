// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title Bafoka Community Contract
 * @dev Manages community-based service exchanges using local digital currency
 * Each community has its own Bafoka variant (Fonjoka, Banjika, etc.)
 */
contract BafokaCommunityContract is ERC20, Ownable, ReentrancyGuard {
    
    // Community structure
    struct Community {
        string name;
        string currencyName;
        uint256 communityId;
        bool exists;
        uint256 totalMembers;
        uint256 totalTransactions;
    }
    
    // User profile structure
    struct UserProfile {
        uint256 communityId;
        string username;
        bool isRegistered;
        uint256 reputation;
        uint256 totalExchanges;
        uint256 joinDate;
        bool isBacker;
    }
    
    // Exchange agreement structure
    struct ExchangeAgreement {
        address provider;
        address receiver;
        uint256 communityId;
        string serviceDescription;
        uint256 bafokaAmount;
        uint256 deadline;
        bool isConfirmed;
        bool isCompleted;
        bool isFinalized;
        uint256 providerRating;
        uint256 receiverRating;
        uint256 createdAt;
    }
    
    // Backer structure for recharging accounts
    struct Backer {
        address backerAddress;
        uint256 communityId;
        string businessName;
        bool isActive;
        uint256 totalRecharges;
        uint256 totalVolume;
    }
    
    // State variables
    mapping(uint256 => Community) public communities;
    mapping(address => UserProfile) public userProfiles;
    mapping(uint256 => ExchangeAgreement) public exchangeAgreements;
    mapping(address => Backer) public backers;
    mapping(uint256 => mapping(address => uint256)) public communityBalances;
    
    // Counters
    uint256 public nextCommunityId;
    uint256 public nextExchangeId;
    uint256 public totalUsers;
    
    // Constants
    uint256 public constant INITIAL_BAFOKA = 1000;
    uint256 public constant MIN_REPUTATION = 0;
    uint256 public constant MAX_REPUTATION = 100;
    
    // Events
    event CommunityCreated(uint256 indexed communityId, string name, string currencyName);
    event UserRegistered(address indexed user, uint256 indexed communityId, string username);
    event BafokaDistributed(address indexed user, uint256 indexed communityId, uint256 amount);
    event ExchangeCreated(uint256 indexed exchangeId, address indexed provider, address indexed receiver, uint256 communityId);
    event ExchangeConfirmed(uint256 indexed exchangeId);
    event ExchangeCompleted(uint256 indexed exchangeId);
    event ExchangeFinalized(uint256 indexed exchangeId, uint256 providerRating, uint256 receiverRating);
    event BackerRegistered(address indexed backer, uint256 indexed communityId, string businessName);
    event BafokaRecharged(address indexed user, address indexed backer, uint256 indexed communityId, uint256 amount);
    
    constructor() ERC20("Bafoka Community Currency", "BAFOKA") {
        nextCommunityId = 1;
        nextExchangeId = 1;
        
        // Create initial communities
        _createCommunity("Fondjomenkwet", "Fonjoka");
        _createCommunity("Banja", "Banjika");
        _createCommunity("Bafouka", "Bafouka");
    }
    
    /**
     * @dev Create a new community
     * @param name Community name
     * @param currencyName Local currency name (e.g., "Fonjoka")
     */
    function _createCommunity(string memory name, string memory currencyName) private {
        communities[nextCommunityId] = Community({
            name: name,
            currencyName: currencyName,
            communityId: nextCommunityId,
            exists: true,
            totalMembers: 0,
            totalTransactions: 0
        });
        
        emit CommunityCreated(nextCommunityId, name, currencyName);
        nextCommunityId++;
    }
    
    /**
     * @dev Register a new user in a specific community
     * @param communityId The community ID to join
     * @param username User's display name
     */
    function registerUser(uint256 communityId, string memory username) external {
        require(communities[communityId].exists, "Community does not exist");
        require(!userProfiles[msg.sender].isRegistered, "User already registered");
        require(bytes(username).length > 0, "Username cannot be empty");
        
        // Create user profile
        userProfiles[msg.sender] = UserProfile({
            communityId: communityId,
            username: username,
            isRegistered: true,
            reputation: 50, // Start with neutral reputation
            totalExchanges: 0,
            joinDate: block.timestamp,
            isBacker: false
        });
        
        // Distribute initial Bafoka
        communityBalances[communityId][msg.sender] = INITIAL_BAFOKA;
        
        // Update counters
        communities[communityId].totalMembers++;
        totalUsers++;
        
        emit UserRegistered(msg.sender, communityId, username);
        emit BafokaDistributed(msg.sender, communityId, INITIAL_BAFOKA);
    }
    
    /**
     * @dev Create a new exchange agreement
     * @param receiver Service receiver address
     * @param serviceDescription Description of the service
     * @param bafokaAmount Amount of Bafoka for the service
     * @param deadline Deadline for completion
     */
    function createExchange(
        address receiver,
        string memory serviceDescription,
        uint256 bafokaAmount,
        uint256 deadline
    ) external returns (uint256) {
        require(userProfiles[msg.sender].isRegistered, "Provider not registered");
        require(userProfiles[receiver].isRegistered, "Receiver not registered");
        require(msg.sender != receiver, "Cannot exchange with yourself");
        
        uint256 communityId = userProfiles[msg.sender].communityId;
        require(userProfiles[receiver].communityId == communityId, "Users must be in same community");
        require(communityBalances[communityId][msg.sender] >= bafokaAmount, "Insufficient Bafoka");
        require(deadline > block.timestamp, "Deadline must be in the future");
        require(bafokaAmount > 0, "Amount must be greater than 0");
        
        // Create exchange agreement
        exchangeAgreements[nextExchangeId] = ExchangeAgreement({
            provider: msg.sender,
            receiver: receiver,
            communityId: communityId,
            serviceDescription: serviceDescription,
            bafokaAmount: bafokaAmount,
            deadline: deadline,
            isConfirmed: false,
            isCompleted: false,
            isFinalized: false,
            providerRating: 0,
            receiverRating: 0,
            createdAt: block.timestamp
        });
        
        // Reserve Bafoka
        communityBalances[communityId][msg.sender] -= bafokaAmount;
        
        emit ExchangeCreated(nextExchangeId, msg.sender, receiver, communityId);
        
        return nextExchangeId++;
    }
    
    /**
     * @dev Confirm an exchange agreement
     * @param exchangeId The exchange ID to confirm
     */
    function confirmExchange(uint256 exchangeId) external {
        ExchangeAgreement storage agreement = exchangeAgreements[exchangeId];
        require(agreement.receiver == msg.sender, "Only receiver can confirm");
        require(!agreement.isConfirmed, "Exchange already confirmed");
        require(!agreement.isCompleted, "Exchange already completed");
        require(block.timestamp <= agreement.deadline, "Exchange deadline passed");
        
        agreement.isConfirmed = true;
        
        emit ExchangeConfirmed(exchangeId);
    }
    
    /**
     * @dev Mark an exchange as completed
     * @param exchangeId The exchange ID to mark as completed
     */
    function markExchangeCompleted(uint256 exchangeId) external {
        ExchangeAgreement storage agreement = exchangeAgreements[exchangeId];
        require(agreement.isConfirmed, "Exchange not confirmed");
        require(!agreement.isCompleted, "Exchange already completed");
        require(msg.sender == agreement.provider || msg.sender == agreement.receiver, "Not authorized");
        
        agreement.isCompleted = true;
        
        emit ExchangeCompleted(exchangeId);
    }
    
    /**
     * @dev Finalize an exchange with ratings
     * @param exchangeId The exchange ID to finalize
     * @param providerRating Rating for the provider (1-5)
     * @param receiverRating Rating for the receiver (1-5)
     */
    function finalizeExchange(
        uint256 exchangeId,
        uint256 providerRating,
        uint256 receiverRating
    ) external nonReentrant {
        ExchangeAgreement storage agreement = exchangeAgreements[exchangeId];
        require(agreement.isCompleted, "Exchange not completed");
        require(!agreement.isFinalized, "Exchange already finalized");
        require(msg.sender == agreement.provider || msg.sender == agreement.receiver, "Not authorized");
        require(providerRating >= 1 && providerRating <= 5, "Invalid provider rating");
        require(receiverRating >= 1 && receiverRating <= 5, "Invalid receiver rating");
        
        // Transfer Bafoka to provider
        communityBalances[agreement.communityId][agreement.provider] += agreement.bafokaAmount;
        
        // Update ratings and reputation
        agreement.providerRating = providerRating;
        agreement.receiverRating = receiverRating;
        agreement.isFinalized = true;
        
        // Update user statistics
        userProfiles[agreement.provider].totalExchanges++;
        userProfiles[agreement.receiver].totalExchanges++;
        
        // Update reputation (simplified algorithm)
        _updateReputation(agreement.provider, providerRating);
        _updateReputation(agreement.receiver, receiverRating);
        
        // Update community statistics
        communities[agreement.communityId].totalTransactions++;
        
        emit ExchangeFinalized(exchangeId, providerRating, receiverRating);
    }
    
    /**
     * @dev Update user reputation based on rating
     * @param user User address
     * @param rating Rating received (1-5)
     */
    function _updateReputation(address user, uint256 rating) private {
        UserProfile storage profile = userProfiles[user];
        
        if (rating >= 4) {
            profile.reputation = profile.reputation < MAX_REPUTATION ? profile.reputation + 1 : MAX_REPUTATION;
        } else if (rating <= 2) {
            profile.reputation = profile.reputation > MIN_REPUTATION ? profile.reputation - 1 : MIN_REPUTATION;
        }
    }
    
    /**
     * @dev Register a backer for a community
     * @param communityId The community ID
     * @param businessName Name of the business
     */
    function registerBacker(uint256 communityId, string memory businessName) external {
        require(communities[communityId].exists, "Community does not exist");
        require(userProfiles[msg.sender].isRegistered, "User not registered");
        require(userProfiles[msg.sender].communityId == communityId, "User not in this community");
        require(bytes(businessName).length > 0, "Business name cannot be empty");
        
        backers[msg.sender] = Backer({
            backerAddress: msg.sender,
            communityId: communityId,
            businessName: businessName,
            isActive: true,
            totalRecharges: 0,
            totalVolume: 0
        });
        
        userProfiles[msg.sender].isBacker = true;
        
        emit BackerRegistered(msg.sender, communityId, businessName);
    }
    
    /**
     * @dev Recharge user's Bafoka account (only backers can do this)
     * @param user User to recharge
     * @param amount Amount of Bafoka to add
     */
    function rechargeBafoka(address user, uint256 amount) external {
        require(backers[msg.sender].isActive, "Not an active backer");
        require(userProfiles[user].isRegistered, "User not registered");
        require(backers[msg.sender].communityId == userProfiles[user].communityId, "Different communities");
        require(amount > 0, "Amount must be greater than 0");
        
        uint256 communityId = backers[msg.sender].communityId;
        
        // Add Bafoka to user's account
        communityBalances[communityId][user] += amount;
        
        // Update backer statistics
        backers[msg.sender].totalRecharges++;
        backers[msg.sender].totalVolume += amount;
        
        emit BafokaRecharged(user, msg.sender, communityId, amount);
    }
    
    /**
     * @dev Get user's Bafoka balance for a specific community
     * @param user User address
     * @param communityId Community ID
     * @return Balance amount
     */
    function getCommunityBalance(address user, uint256 communityId) external view returns (uint256) {
        return communityBalances[communityId][user];
    }
    
    /**
     * @dev Get user profile information
     * @param user User address
     * @return Profile information
     */
    function getUserProfile(address user) external view returns (UserProfile memory) {
        return userProfiles[user];
    }
    
    /**
     * @dev Get community information
     * @param communityId Community ID
     * @return Community information
     */
    function getCommunity(uint256 communityId) external view returns (Community memory) {
        return communities[communityId];
    }
    
    /**
     * @dev Get exchange agreement details
     * @param exchangeId Exchange ID
     * @return Exchange agreement details
     */
    function getExchangeAgreement(uint256 exchangeId) external view returns (ExchangeAgreement memory) {
        return exchangeAgreements[exchangeId];
    }
    
    /**
     * @dev Get backer information
     * @param backer Backer address
     * @return Backer information
     */
    function getBacker(address backer) external view returns (Backer memory) {
        return backers[backer];
    }
    
    /**
     * @dev Get total users in a community
     * @param communityId Community ID
     * @return Total member count
     */
    function getCommunityMemberCount(uint256 communityId) external view returns (uint256) {
        return communities[communityId].totalMembers;
    }
    
    /**
     * @dev Get total transactions in a community
     * @param communityId Community ID
     * @return Total transaction count
     */
    function getCommunityTransactionCount(uint256 communityId) external view returns (uint256) {
        return communities[communityId].totalTransactions;
    }
}
