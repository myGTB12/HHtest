pragma solidity 0.8.14;

import "./ERC20.sol";
import "./ERC20_Token.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Vesting is ERC20, Ownable{
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
        uint256 currentTimeClaimed;
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
        uint256 _timePerPeriods;
    }
    modifier onlyAdmin(){
        require(msg.sender = ADMIN);
    }
    function fundVesting() Ownable{
        approve(ADMIN, 100000000);
        allowance(_token, ADMIN);
        
    }
     
    function whiteList(){
        for(uint i = 0; i < whiteList.length; i++){
            whiteList.push(buyerInfo);
        }
    }
    function claimToken(){
        require(buyerInfo[msg.sender].);
        transferFrom(ADMIN, msg.sender, buyerInfo[msg.sender].valueOutput);
    } 
}