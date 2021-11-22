pragma solidity >=0.6.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ExerciceSolutionToken is ERC20 {

	address public owner;
    mapping(address => bool) public minter;
    uint8 public initdecimals = 18;

	constructor() public ERC20("Exsoto", "EST") {
        owner = msg.sender;
        _setupDecimals(initdecimals);
    }

    function setMinter(address minterAddress, bool isMinter) public {
        require(owner == msg.sender, "You are not the owner of this contract and cannot set a minter");
        minter[minterAddress] = isMinter;
    }

    function mint(address toAddress, uint256 amount)  public {
        require(isMinter(msg.sender), "You are not a minter");
        _mint(toAddress, amount);
    }

    function burn(address account, uint256 amount)  public {
        require(isMinter(msg.sender), "You are not a minter");
        _burn(account, amount);
    }

    function isMinter(address minterAddress) public returns (bool) {
        if (minter[minterAddress]) {
            return true;
        }
        else {
            return false;
        }
    }

}
