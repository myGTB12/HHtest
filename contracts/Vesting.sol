pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./ERC20.sol";


contract VestingToken is Ownable{
    uint256 public firstRelease;
    uint256 private clif;
    uint256 private startTime;
    uint256 private totalPeriods;
    uint256 private timePerPeriods;
    ERC20 public token;
    uint256 public totalToken;
    address private ADMIN = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    mapping(address => uint256) public balances;
    mapping(address => BuyerInfor) public buyerInfors;
    mapping(address => mapping(address => uint256)) private _allowances;

    event claim(address sender, address indexed receiver, uint256 token_out);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event FundVesting(uint256 amountToken);

    struct BuyerInfor{
        uint256 claimedPeriods;         //số period đã claim
        uint256 currentTimeClaim;       //thời gian laim
        uint256 amount;                 //tổng sô token investor có thể claim
        uint256 claimableToken;         //số token có thể claim
        bool claimedInCliff;            //đã claim trong đợt cliff?
        uint256 totalClaimedPeriods;    //số chu kì đã claim
    }

    constructor(
        address _token,
        uint256 _firstRelease, 
        uint256 _clif,      
        uint256 _totalPeriod,   
        uint256 _timePerPeriods,
        uint256 _totalToken
        ) payable{
        token = ERC20(_token);
        firstRelease = _firstRelease;
        totalPeriods = _totalPeriod;
        clif = _clif;
        timePerPeriods = _timePerPeriods;
        totalToken = _totalToken;
        balances[ADMIN] += totalToken;
        }
    function time() public view returns(uint256){
        return block.timestamp;
    }
    function fundVesting() public onlyOwner{
        allowance(ADMIN, address(this));
        transfer(address(this), totalToken);
        emit FundVesting(totalToken);
    }
    function addWhiteList(address whiteListAdress) public{
        buyerInfors[whiteListAdress].claimableToken = 0;
        buyerInfors[whiteListAdress].currentTimeClaim = block.timestamp;
        buyerInfors[whiteListAdress].totalClaimedPeriods = 0;
        buyerInfors[whiteListAdress].claimedInCliff = false;
        buyerInfors[whiteListAdress].claimedPeriods = 0; 
        buyerInfors[whiteListAdress].amount = 10000;
    }
    function claimToken() public payable{
        require(block.timestamp >= buyerInfors[msg.sender].currentTimeClaim + clif , "NOT TIME TO CLAIM TOKEN");
        require(buyerInfors[msg.sender].claimedPeriods < totalPeriods, "CLAIMED 8 PERIODS");
        if(buyerInfors[msg.sender].currentTimeClaim + clif <= block.timestamp && block.timestamp <= firstRelease + clif + timePerPeriods){
            approve(msg.sender, buyerInfors[msg.sender].amount);
            transferFrom(address(this), msg.sender, (buyerInfors[msg.sender].amount*2)/10);
            emit claim(ADMIN, msg.sender, (buyerInfors[msg.sender].amount*2)/10);
            buyerInfors[msg.sender].claimedInCliff = true;
        }
        else{
            uint256 token20 = 0;
            if(buyerInfors[msg.sender].claimedInCliff == false){
                token20 = (buyerInfors[msg.sender].amount*2)/10;
            }
            uint256 tokenPerPeriod = buyerInfors[msg.sender].amount / 10; //10% token của investor
            uint256 checkPeriod = (block.timestamp - buyerInfors[msg.sender].currentTimeClaim)/timePerPeriods - 
            buyerInfors[msg.sender].claimedPeriods;     //check period = số chu kì - số chu kì đã claim
            approve(msg.sender, buyerInfors[msg.sender].amount);
            transferFrom(address(this), msg.sender, (tokenPerPeriod * checkPeriod) + token20); 
            emit claim(ADMIN, msg.sender, buyerInfors[msg.sender].amount);
            buyerInfors[msg.sender].claimedPeriods += checkPeriod;   //số lần đã claim tăng theo số chu kì đã claim 
            
        }
        //  if(buyerInfors[msg.sender].currentTimeClaim <= firstRelease + clif){     //và sô chu kì phải nhỏ hơn 8

        //     approve(msg.sender,buyerInfors[msg.sender].amount);
        
        //     transferFrom(address(this), msg.sender, buyerInfors[msg.sender].amount);      //Nếu pass require thì check tiếp thời gian
        //     BuyerInfor memory buyerInfor1;                                      //có trong khoảng cliff thì cho claim 20%
        //     buyerInfors[msg.sender] = buyerInfor1;                           
        //     emit claim(ADMIN, msg.sender, buyerInfors[msg.sender].amount);
        //     buyerInfors[msg.sender].claimedInCliff = true;
        // }
        // else{                               //còn lại sẽ là thời gian claim của 8 periods
        //     uint256 token20 = 0;
        //     if(buyerInfors[msg.sender].claimedInCliff == false){         //nếu đã claim 20% ở giai đoạn cliff thì sẽ là true
        //         token20 = totalToken / 20;                       
        //     }
        //     uint256 tokenPerPeriod = totalToken / 10; //10% token của investor
        //     uint256 checkPeriod = (((buyerInfors[msg.sender].currentTimeClaim - clif - firstRelease) / 2629743) - 
        //     buyerInfors[msg.sender].claimedPeriods);     //check period = số chu kì - số chu kì đã claim
        //     approve(msg.sender, buyerInfors[msg.sender].amount);
        //     transferFrom(address(this), msg.sender, 100);//(tokenPerPeriod * checkPeriod) + token20); 
        //     BuyerInfor memory buyerInfor1;
        //     buyerInfors[msg.sender] = buyerInfor1;
        //     emit claim(ADMIN, msg.sender, buyerInfors[msg.sender].amount);
        //     buyerInfors[msg.sender].claimedPeriods += checkPeriod;   //số lần đã claim tăng theo số chu kì đã claim
        // }
    }

    function transfer(address to, uint256 amount) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public virtual returns (bool) {
        address owner = address(this);
        _approve(owner, spender, amount);
        return true;
    }
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 fromBalance = balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            balances[from] = fromBalance - amount;
        }
        balances[to] += amount;

        emit Transfer(from, to, amount);
    }
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}