pragma solidity 0.4.16;

import "./ERC20.sol";
import "./ERC20_Token.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Vesting is ERC20{
    using SafeMath for uint256;
    ERC20Interface public token;
    uint256 public firstRelease;
    uint256 public startTime;
    uint256 public totalPeriods;
    uint256 public timePerPeriods;
    uint256 public clif;
    uint256 public totalToken;
    address ADMIN = 0x887872dfFC74C69B8d111390925DD4C6CF78E796;
    buyerInfo[100] public whiteList;

    struct BuyerInfo{
        uint256 amount;
        uint256 tokenClaimed;
    }
    mapping(address => BuyerInfo) public buyerInfo;
    constructor(){
        address _token;
        uint256 _firstRelease;
        uint256 _startTime;
        uint256 _clif;
        uint256 _totalPeriod;
        uint256 _ timePerPeriods;
    }
    modifier onlyAdmin(){
        require(msg.sender = ADMIN);
    }
    function fundVesting() is Ownable{
        // Transfer(msg.sender, whiteList, BuyerInfo.amount)
         for(uint i = 0; i < whiteList.length; i++){
            Transfer(msg.sender, whiteList[i], BuyerInfo.amount);
        }
    }
    function whiteList(){
        for(uint i = 0; i < whiteList.length; i++){
            whiteList.push(buyerInfo);
        }
    }
    function claimToken(){
        require(buyerInfo[msg.sender].currnetTimeClaim < block.timestamp, "NOT TIME TO CLIAM TOKEN");
        transferFrom(ADMIN, msg.sender, buyerInfo[msg.sender].valueOutput);
    } 
}