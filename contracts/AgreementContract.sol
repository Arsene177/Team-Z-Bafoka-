// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AgreementContract {
    struct Agreement {
        address serviceProvider;
        address serviceReceiver;
        string serviceDescription;
        uint256 serviceHours;
        uint256 createdAt;
        bool isConfirmed;
        bool isCompleted;
        bool isFinalized;
    }

    struct UserReputation {
        uint256 totalAgreements;
        uint256 completedAgreements;
        uint256 positiveRatings;
        uint256 totalRatings;
    }

    mapping(uint256 => Agreement) public agreements;
    mapping(address => UserReputation) public userReputations;
    mapping(address => uint256[]) public userAgreements;

    uint256 public agreementCounter;
    uint256 public serviceCreditRate = 1; // 1 hour = 1 credit

    event AgreementCreated(uint256 indexed agreementId, address indexed provider, address indexed receiver, string description, uint256 serviceHours);
    event AgreementConfirmed(uint256 indexed agreementId);
    event AgreementCompleted(uint256 indexed agreementId);
    event AgreementFinalized(uint256 indexed agreementId, uint256 providerRating, uint256 receiverRating);

    function createAgreement(
        address _serviceReceiver,
        string memory _serviceDescription,
        uint256 _serviceHours
    ) public returns (uint256) {
        require(_serviceReceiver != address(0), "Invalid receiver address");
        require(_serviceHours > 0, "Service hours must be greater than 0");
        require(bytes(_serviceDescription).length > 0, "Service description cannot be empty");

        agreementCounter++;
        uint256 agreementId = agreementCounter;

        agreements[agreementId] = Agreement({
            serviceProvider: msg.sender,
            serviceReceiver: _serviceReceiver,
            serviceDescription: _serviceDescription,
            serviceHours: _serviceHours,
            createdAt: block.timestamp,
            isConfirmed: false,
            isCompleted: false,
            isFinalized: false
        });

        userAgreements[msg.sender].push(agreementId);
        userAgreements[_serviceReceiver].push(agreementId);

        emit AgreementCreated(agreementId, msg.sender, _serviceReceiver, _serviceDescription, _serviceHours);
        return agreementId;
    }

    function confirmAgreement(uint256 _agreementId) public {
        Agreement storage agreement = agreements[_agreementId];
        require(agreement.serviceReceiver == msg.sender, "Only service receiver can confirm");
        require(!agreement.isConfirmed, "Agreement already confirmed");
        require(!agreement.isFinalized, "Agreement already finalized");

        agreement.isConfirmed = true;
        emit AgreementConfirmed(_agreementId);
    }

    function markAgreementCompleted(uint256 _agreementId) public {
        Agreement storage agreement = agreements[_agreementId];
        require(agreement.serviceProvider == msg.sender, "Only service provider can mark as completed");
        require(agreement.isConfirmed, "Agreement must be confirmed first");
        require(!agreement.isCompleted, "Agreement already completed");

        agreement.isCompleted = true;
        emit AgreementCompleted(_agreementId);
    }

    function finalizeAgreement(uint256 _agreementId, uint256 _providerRating, uint256 _receiverRating) public {
        Agreement storage agreement = agreements[_agreementId];
        require(agreement.serviceReceiver == msg.sender, "Only service receiver can finalize");
        require(agreement.isCompleted, "Agreement must be completed first");
        require(!agreement.isFinalized, "Agreement already finalized");
        require(_providerRating >= 1 && _providerRating <= 5, "Rating must be between 1 and 5");
        require(_receiverRating >= 1 && _receiverRating <= 5, "Rating must be between 1 and 5");

        agreement.isFinalized = true;

        // Update reputations
        UserReputation storage providerRep = userReputations[agreement.serviceProvider];
        UserReputation storage receiverRep = userReputations[agreement.serviceReceiver];

        providerRep.totalAgreements++;
        providerRep.completedAgreements++;
        providerRep.totalRatings++;
        if (_providerRating >= 4) {
            providerRep.positiveRatings++;
        }

        receiverRep.totalAgreements++;
        receiverRep.completedAgreements++;
        receiverRep.totalRatings++;
        if (_receiverRating >= 4) {
            receiverRep.positiveRatings++;
        }

        emit AgreementFinalized(_agreementId, _providerRating, _receiverRating);
    }

    function getAgreement(uint256 _agreementId) public view returns (
        address serviceProvider,
        address serviceReceiver,
        string memory serviceDescription,
        uint256 serviceHours,
        uint256 createdAt,
        bool isConfirmed,
        bool isCompleted,
        bool isFinalized
    ) {
        Agreement storage agreement = agreements[_agreementId];
        return (
            agreement.serviceProvider,
            agreement.serviceReceiver,
            agreement.serviceDescription,
            agreement.serviceHours,
            agreement.createdAt,
            agreement.isConfirmed,
            agreement.isCompleted,
            agreement.isFinalized
        );
    }

    function getUserReputation(address _user) public view returns (
        uint256 totalAgreements,
        uint256 completedAgreements,
        uint256 positiveRatings,
        uint256 totalRatings
    ) {
        UserReputation storage rep = userReputations[_user];
        return (
            rep.totalAgreements,
            rep.completedAgreements,
            rep.positiveRatings,
            rep.totalRatings
        );
    }

    function getUserAgreements(address _user) public view returns (uint256[] memory) {
        return userAgreements[_user];
    }

    function getAgreementCount() public view returns (uint256) {
        return agreementCounter;
    }
} 