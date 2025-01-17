pragma solidity >=0.6.0;

interface IERC20Claimable {

    function claimTokens() external;

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
