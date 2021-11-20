pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./IERC20Claimable.sol";

contract ExerciceSolution {

    mapping(address => uint256) public claimedTokenTracker;
    IERC20Claimable claimableERC20;

    constructor() public {
        claimableERC20 = IERC20Claimable(0xB27D1077A6c63500CCC0ACce75E05A5EDbB56230);
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
        
        success = claimableERC20.transfer(msg.sender, amountToWithdraw);
        
        if (success) {
            return amountToWithdraw;
        } 
        else {
            return 0;
        }
    }
}