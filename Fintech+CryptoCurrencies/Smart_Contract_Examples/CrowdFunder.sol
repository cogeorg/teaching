pragma solidity ^0.4.11;

contract CrowdFunder {
    
    address public creator;
    address public fundRecipient; // creator may be different from recipient of the funds
    uint public minimumToRaise;
    string campaignUrl; 

    enum State {
        Fundraising,
        ExpiredRefund,
        Successful,
        Closed
    }

    struct Contribution {
        uint amount;
        address contributor;
    }

    State public state = State.Fundraising;
    uint public totalRaised;
    uint public currentBalance;
    uint public raiseBy;
    uint public completeAt;
    Contribution[] contributions;

    event LogFundingReceived(address addr, uint amount, uint currentTotal);
    event LogWinnerPaid(address winnerAddress);
    event LogFunderInitialized(
        address creator,
        address fundRecipient,
        string url,
        uint _minimumToRaise, 
        uint256 raiseBy
    );

    modifier inState(State _state) {
        require (state == _state);
        _;
    }

    modifier isCreator() {
        require (msg.sender == creator);
        _;
    }

    modifier atEndOfLifecycle() {
        require(((state == State.ExpiredRefund || state == State.Successful) && completeAt + 1 hours < now));
        _;
    }

    function CrowdFunder(
        uint timeInHoursForFundraising,
        string _campaignUrl,
        address _fundRecipient,
        uint _minimumToRaise)
    {
        creator = msg.sender;
        fundRecipient = _fundRecipient;
        campaignUrl = _campaignUrl;
        minimumToRaise = _minimumToRaise* 1000000000000000000; //convert to wei
        raiseBy = now + (timeInHoursForFundraising * 1 hours);
        currentBalance = 0;
        LogFunderInitialized(
            creator,
            fundRecipient,
            campaignUrl,
            minimumToRaise,
            raiseBy);
    }

    function contribute()
    public
    inState(State.Fundraising) payable returns (uint256)
    {
        contributions.push(
            Contribution({
                amount: msg.value,
                contributor: msg.sender
                })
            );
        totalRaised += msg.value;
        currentBalance = totalRaised;
        LogFundingReceived(msg.sender, msg.value, totalRaised);

        checkIfFundingCompleteOrExpired();
        return contributions.length - 1; // transaction id
    }

    function checkIfFundingCompleteOrExpired() {
        if (totalRaised > minimumToRaise) {
            state = State.Successful;
            payOut();

            } else if ( now > raiseBy )  {
                state = State.ExpiredRefund; 
            }
            completeAt = now;
        }

        function payOut()
        public
        inState(State.Successful)
        {
            require(fundRecipient.send(this.balance));
            state = State.Closed;
            currentBalance = 0;
            LogWinnerPaid(fundRecipient);
        }

        function getRefund(uint256 id)
        public
        inState(State.ExpiredRefund) 
        returns (bool)
        {
            require (contributions.length <= id || id < 0 || contributions[id].amount == 0 );

            uint amountToRefund = contributions[id].amount;
            contributions[id].amount = 0;

            if(!contributions[id].contributor.send(amountToRefund)) {
                contributions[id].amount = amountToRefund;
                return false;
            }
            else{
                totalRaised -= amountToRefund;
                currentBalance = totalRaised;
            }

            return true;
        }

        function removeContract()
        public
        isCreator()
        atEndOfLifecycle()
        {
            selfdestruct(msg.sender);
        }

        function () {}
    }