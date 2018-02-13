pragma solidity ^0.4.0;

contract SimpleAuction {

    address public beneficiary;
    uint public auctionEnd;

    address public highestBidder;
    uint public highestBid;

    mapping (address => uint) pendingReturn;

    bool ended;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    /// Create a simple auction with `_biddingTime`
    /// seconds bidding time on behalf of the
    /// beneficiary address `_beneficiary`.
    function SimpleAuction(uint _biddingTime, address _beneficiary) public {
        beneficiary = _beneficiary;
        auctionEnd = now + _biddingTime;
    }

    function bid() public payable {
        require(now <= auctionEnd);
        require(msg.value > highestBid);

        if (highestBidder != 0) {
            pendingReturn[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        HighestBidIncreased(msg.sender, msg.value);
    }

    /// Withdraw a bid that was overbid.
    function withdraw() public returns (bool) {
        uint amount = pendingReturn[msg.sender];

        if (amount > 0) {
            pendingReturn[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                pendingReturn[msg.sender] = amount;
                return false;
            }
        }

        return true;
    }

    function auctionEnd() public {
        require(now >= auctionEnd);
        require(!ended);

        ended = true;
        AuctionEnded(highestBidder, highestBid);

        beneficiary.transfer(highestBid);
    }

}