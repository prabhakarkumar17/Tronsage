pragma solidity ^0.6.0;

contract tron {
    struct user{
        string name;
        uint age;
        address payable userAddress;
        uint usedReferalCode;
        uint referalCode;
        uint counter;
    }
    
    address payable[] referalCodeAddress;
    uint[] referalCodeArray;
    user u;
    uint randomNo;
    uint copyOfRandomNo;
    
    function getReferalCode() public returns(uint){
        randomNo = random();
        copyOfRandomNo = randomNo;
        return randomNo;
    } 
    
    mapping (uint => user) referal;
    mapping (uint => uint[]) directConnections;
    
    function signup (string memory _name, uint _age, uint _usedReferalCode) public returns(uint){
        referal[randomNo].referalCode = randomNo;
        referal[randomNo].name = _name;
        referal[randomNo].age = _age;
        referal[randomNo].userAddress = msg.sender;
        referal[randomNo].usedReferalCode = _usedReferalCode;
        
        return referal[randomNo].referalCode;
    }
    
    function transferReward(uint _amount) public payable returns(address payable[] memory, uint[] memory) {
        

            delete referalCodeAddress; // referalCodeAddress.length = 0;
            delete referalCodeArray; 
            uint presentReferalCode = copyOfRandomNo;
            
             while(referal[copyOfRandomNo].usedReferalCode>0){
                 referalCodeAddress.push(referal[referal[copyOfRandomNo].usedReferalCode].userAddress);
                 referalCodeArray.push(referal[referal[copyOfRandomNo].usedReferalCode].referalCode);
                 referal[referal[copyOfRandomNo].usedReferalCode].counter++;
                 copyOfRandomNo = referal[copyOfRandomNo].usedReferalCode;
             }
             
             directConnections[referal[presentReferalCode].usedReferalCode].push(referal[presentReferalCode].referalCode);
            return (referalCodeAddress, referalCodeArray);

    }
    
    function getNoConnection(uint _referelCode) public returns(uint, uint[] memory){
        return (referal[_referelCode].counter, directConnections[_referelCode]);
    }
    
    function random() private view returns (uint) {
       return uint(uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 900);
   }
}
