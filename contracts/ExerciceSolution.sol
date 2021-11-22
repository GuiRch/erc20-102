pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./ExerciceSolutionToken.sol";
import "./IERC20Claimable.sol";

contract ExerciceSolution {
    
    mapping(address => uint256) public claimedTokenTracker;
	address public exsotoAddress;

    IERC20Claimable claimableERC20;
    ExerciceSolutionToken exSoTo;


    constructor(ExerciceSolutionToken _exSoTo) public {
        exsotoAddress = address(_exSoTo);
        exSoTo = _exSoTo;
        claimableERC20 = IERC20Claimable(0xb5d82FEE98d62cb7Bc76eabAd5879fa4b29fFE94);
	}

	fallback () external payable 
	{}

	receive () external payable 
	{}

    function claimTokensOnBehalf() public {
        uint256 lastBalance = claimableERC20.balanceOf(address(this));
        claimableERC20.claimTokens();
        uint256 newBalance = claimableERC20.balanceOf(address(this));
        claimedTokenTracker[msg.sender] = claimedTokenTracker[msg.sender] + (newBalance - lastBalance);
    }

    function tokensInCustody(address callerAddress) public returns (uint256) {
        return claimedTokenTracker[callerAddress];
    }

    function withdrawTokens(uint256 amountToWithdraw) public returns (uint256) {
        require(claimedTokenTracker[msg.sender] > 0, "No tokens in custody");
        require(amountToWithdraw <= claimedTokenTracker[msg.sender], "Trying to remove more tokens than in custody");
        
        bool success = claimableERC20.transfer(msg.sender, amountToWithdraw);
        
        if (success) {
            claimedTokenTracker[msg.sender] = claimedTokenTracker[msg.sender] - amountToWithdraw;
            return amountToWithdraw;
        } 
        else {
            return 0;
        }
    }

    function depositTokens(uint256 amountToWithdraw) public returns (uint256) {
        bool success = claimableERC20.transferFrom(msg.sender, address(this), amountToWithdraw);

        if (success) {
            claimedTokenTracker[msg.sender] = claimedTokenTracker[msg.sender] + amountToWithdraw;
            exSoTo.mint(msg.sender, amountToWithdraw);
            return amountToWithdraw;
        }
        else {
            return 0;
        }
    }

    function getERC20DepositAddress() public returns (address) {
        return exsotoAddress;
    }
}