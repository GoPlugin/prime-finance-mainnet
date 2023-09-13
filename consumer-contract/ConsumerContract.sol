pragma solidity ^0.4.24;

interface IInvokeOracle {
    function requestData(address _authorizedWalletAddress,string  fromIndex) external returns (uint256 requestId);

    function showPrice(uint256 _reqid) external view returns (uint256 answer, uint256 updatedOn, uint8 decimal);

    function getDecimalForRequest(uint256 _reqid) external view returns(uint8 decimal);
}

contract ConsumerContract {
    address CONTRACTADDR = 0x7b28d40DBBC1699A2dD3EfAa2D86c3C7aeaa5213;
    uint256 public requestId;
    address private owner;
    mapping (uint256 => string) public priceIndexUsedInRequestID;

    constructor() public{
        owner = msg.sender;
    }

    //Fund this contract with sufficient PLI, before you trigger below function.
    //Note, below function will not trigger if you do not put PLI in above contract address
    function getPriceInfo(string  fromPriceIndex) external returns (uint256) {
        require(msg.sender==owner,"Only owner can trigger this");
        (requestId) = IInvokeOracle(CONTRACTADDR).requestData({_authorizedWalletAddress:owner,fromIndex:fromPriceIndex});
        priceIndexUsedInRequestID[requestId] = fromPriceIndex;
        return requestId;
    }

    //TODO - you can customize below function as you want, but below function will give you the pricing value
    //This function will give you last stored value in the contract
    function show(uint256 _id) external view returns (uint256 responseAnswer, uint256 timestamp,uint8 decimalValue) {
        (uint256 answer, uint256 updatedOn,uint8 decimal) = IInvokeOracle(CONTRACTADDR).showPrice({_reqid: _id});
        return (answer,updatedOn,decimal);
    }

    function getDecimal(uint256 _id) external view returns(uint8 decimalValue){
        return IInvokeOracle(CONTRACTADDR).getDecimalForRequest({_reqid: _id});
    }
}
