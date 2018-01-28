pragma solidity ^0.4.9;
 
 /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
contract SafeMath {
    uint256 constant public MAX_UINT256 =
    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
        if (x > MAX_UINT256 - y) throw;
        return x + y;
    }

    function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
        if (x < y) throw;
        return x - y;
    }

    function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
        if (y == 0) return 0;
        if (x > MAX_UINT256 / y) throw;
        return x * y;
    }
}


/* @dev The Ownable contract has an owner address, and provides basic authorization control
* functions, this simplifies the implementation of "user permissions".
*/
contract Ownable {
  address public owner;


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}

 contract ContractReceiver is Ownable, SafeMath{
    function tokenFallback(address _from, uint _value, bytes _data);
}

contract HNP2Ship is ContractReceiver{
    address public HNPcontract;
    mapping (uint => address) public ship2owner;
    mapping (address => uint) public ownerShipCount;
    uint8 public decimals = 0;
    string[] public ships;
    uint public priceforCL = 50;
    uint public priceforCA = 500;
    uint public priceforBB = 5000;
    uint public priceforGhost =100000;
    // Function to access decimals of token .
      function decimals() constant returns (uint8 _decimals) {
          return decimals;
      }
    function setprice(uint _cl,uint _ca, uint _bb, uint _ghost) onlyOwner{
        priceforCL = _cl;
        priceforCA = _ca;
        priceforBB = _bb;
        priceforGhost = _ghost;
    }


    function setHNPcontract(address _newaddress) onlyOwner{
        HNPcontract = _newaddress;
    }

    function tokenFallback(address _from, uint _value, bytes _data){
        require(msg.sender == HNPcontract);
        require(_value > priceforCL);
        string memory cdkey;
        uint id;
        if (_value >=priceforCL && _value <priceforCA) {
            cdkey = "a CL ship";
            id = ships.push(cdkey) - 1;
            ship2owner[id] = _from;
            ownerShipCount[_from]++;
        }
        else if (_value >=priceforCA && _value <priceforBB) {
            cdkey = "a CA ship";
            id = ships.push(cdkey) - 1;
            ship2owner[id] = _from;
            ownerShipCount[_from]++;
        }
        else if (_value >=priceforBB && _value <priceforGhost) {
            cdkey = "a BB ship";
            id = ships.push(cdkey) - 1;
            ship2owner[id] = _from;
            ownerShipCount[_from]++;
        }
        else if (_value >=priceforGhost) {
            cdkey = "a Ghost ship";
            id = ships.push(cdkey) - 1;
            ship2owner[id] = _from;
            ownerShipCount[_from]++;
        }
    }

    function getship(address _owner) public view returns(uint[]){
        uint[] memory result = new uint[](ownerShipCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < ships.length; i++) {
          if (ship2owner[i] == _owner) {
            result[counter] = i;
            counter++;
          }
        }
        return result;
    }   
    function getship() public view returns(uint[]){
        uint[] memory result = new uint[](ownerShipCount[msg.sender]);
        uint counter = 0;
        for (uint i = 0; i < ships.length; i++) {
          if (ship2owner[i] == msg.sender) {
            result[counter] = i;
            counter++;
          }
        }
        return result;
    }
    function getcdkey(uint _id) public view returns(string){
        return ships[_id];
    }


}
