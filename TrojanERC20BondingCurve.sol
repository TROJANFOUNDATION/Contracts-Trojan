contract TrojanERC20BondingCurve is Initializable, BondingCurveToken {

  /* Reserve Token */
  ERC20 public reserveToken;

  function initialize(ERC20 _reserveToken, uint256 _initialPoolBalance, uint256 _initialSupply, uint32 _reserveRatio, uint256 _gasPrice) initializer public {
    reserveToken = _reserveToken;
    require(reserveToken.transferFrom(msg.sender, this, _initialPoolBalance), "ERC20BondingToken: Failed to transfer tokens for intial pool.");
    BondingCurveToken.initialize(_initialSupply, _reserveRatio, _gasPrice);
  }

  /**
   * @dev Mint tokens
   *
   * @param amount Amount of tokens to deposit
   */
  function _curvedMint(uint256 amount) internal returns (uint256) {
    require(reserveToken.transferFrom(msg.sender, this, amount));
    super._curvedMint(amount);
  }

  /**
   * @dev Burn tokens
   *
   * @param amount Amount of tokens to burn
   */
  function _curvedBurn(uint256 amount) internal returns (uint256) {
    uint256 reimbursement = super._curvedBurn(amount);
    reserveToken.transfer(msg.sender, reimbursement);
  }

  function poolBalance() public view returns(uint256) {
    return reserveToken.balanceOf(this);
  }
}
pragma solidity ^0.4.24;



contract Token is ERC20BondingToken {
  uint256 public constant INITIAL_POOL_BALANCE = 1 * (10 ** 18);
  uint256 public constant INITIAL_SUPPLY = 1000000 * (10 ** 18);
  uint32 public constant RESERVE_RATIO = 150000;
  uint256 public constant GAS_PRICE = 50 * (10 ** 10);

  constructor(ERC20 _reserveToken) public {
    ERC20BondingToken.initialize(
      _reserveToken,
      INITIAL_POOL_BALANCE,
      INITIAL_SUPPLY,
      RESERVE_RATIO,
      GAS_PRICE
    );
  }
}
