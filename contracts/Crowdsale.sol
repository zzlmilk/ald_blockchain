pragma solidity ^0.4.16;

contract token {

    function transferToAddress(address _from,address _to, uint amount) public returns(uint);

    function getBalanceOf(address _address) public returns(uint);
}

contract Crowdsale {

    address public beneficiary = 0x7d8E477BffF53FCAa49e19198b55AD00ed23F075;  // 募资成功后的收款方

    uint public price = 100;    //  token 与以太坊的汇率 , token卖多少钱

    uint public minTokenNumber = 2;

    uint public maxTokenNumber = 3;

    token public tokenReward;

    address public owner;

    bool public isFreezeStatus = false;

    address public company_give_token_address; //公司发送代币地址

    address[] public whiteList = [0x39EcFc11af9ecD1b438fc2E2391aac801D4810AB,0x5ba67A404c5eB63f3733bC1b5fB6b3B9D02f8e64];

    /**
    * 事件可以用来跟踪信息
    **/
    event FinishBuy(address recipient, uint totalAmountRaised);

    /**
     * 构造函数, 设置相关属性
     */
    /* constructor(address _company_give_token_address,bool _isFreezeStatus) public {

        company_give_token_address = _company_give_token_address;

        isFreezeStatus = _isFreezeStatus;

        tokenReward = token(0x62F41ecCd027033a336313Bfd65BECa892A48c72);
    } */

    constructor() public {

        company_give_token_address = 0x6fe650379c5643cBD9FE36A2cbDba852A25DDfb4;

        tokenReward = token(0x4Bd93263bA6D6c7f7c7c36ED155D5D1C7F300132);
    }

    function setFreezeStatus(bool _freezeStatus) public{

       isFreezeStatus = _freezeStatus;
    }

    function dealWhiteList(address _to) private view returns(uint){

      uint _can_white_list = 0;

        for(uint i = 0 ; i < whiteList.length; i++){

            if(whiteList[i] == _to){

                _can_white_list = 1;

                break;
            }
        }

        return (_can_white_list);
    }

    function dealMaxAndMaxBuyNumber(uint _amout) private view returns(uint){

      uint _buy = 0;

      if(_amout >= minTokenNumber && _amout <= maxTokenNumber){

          _buy = 1;
      }

      return (_buy);
    }

    function sendCode() payable public {

      address sender_addres = msg.sender;

      //uint address_banlance = sender_addres.balance / 1 ether;

      uint _company_give_token_amout = tokenReward.getBalanceOf(company_give_token_address);

      uint _send_code_status = 0; //异常错误

      uint _can_white_list = dealWhiteList(msg.sender);

      uint _amout = ( msg.value / 1 ether ) * 10 ** uint256(18);

      uint _exchange_token_amout = _amout * price;

      uint _min_max_number = dealMaxAndMaxBuyNumber(_amout);

      if(_can_white_list == 0){

        _send_code_status = 100; //用户不存在白名单中

      } else if(_min_max_number == 0){

        _send_code_status = 101; //用户输入的金额超过最小 最大限制

      } else if(isFreezeStatus == true){

        _send_code_status = 102;  //代币已被冻结，无法兑换

      } else if(_company_give_token_amout <  _exchange_token_amout){

        _send_code_status = 103; //代币数量不足
      }

      if(_send_code_status == 0){

         beneficiary.transfer(msg.value);

         tokenReward.transferToAddress(company_give_token_address,msg.sender,_exchange_token_amout);

         _send_code_status = 200; //成功

      } else{

          msg.sender.transfer(msg.value); //如出现错误  将比特币还给用户
      }

      emit FinishBuy(msg.sender,_send_code_status);
    }
}
