const Crowdsale = artifacts.require("./Crowdsale.sol");

function dealReturnStatus(result){

  for (var i = 0; i < result.logs.length; i++) {

     var log = result.logs[i];

     if (log.event == "FinishBuy") {

       let _request_status = log.args.totalAmountRaised.valueOf();

       switch(parseInt(_request_status)){

         case 100:

           console.log('用户不存在白名单中');

           break;

         case 101:

           console.log('用户输入的金额超过最小 最大限制');

           break;

         case 102:

           console.log('代币已被冻结');

           break;

         case 103:

           console.log('代币数量不足');

           break;

         case 200:

           console.log('兑换成功');

           break;
       }
       break;
     }
   }
}

contract('Crowdsale test', function(accounts) {
  it("非白名单测试", function() {
    return Crowdsale.deployed().then(function(instance) {
      return instance.sendCode({
        from:'0x6fe650379c5643cBD9FE36A2cbDba852A25DDfb4',
        value:web3.toWei('0.1','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });

  it("白名单测试 输入金额符合要求 非冻结状态", function() {
    return Crowdsale.deployed().then(function(instance) {
      return instance.sendCode({
        from:'0xEd6Ac7925a5c727A7359DF3033ebc4Be00Ec9885',
        value:web3.toWei('2','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });

  it("白名单 最小限额测试", function() {
    return Crowdsale.deployed().then(function(instance) {
      return instance.sendCode({
        from:'0xEd6Ac7925a5c727A7359DF3033ebc4Be00Ec9885',
        value:web3.toWei('1','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });

  it("白名单 最大限额测试", function() {
    return Crowdsale.deployed().then(function(instance) {
      return instance.sendCode({
        from:'0xEd6Ac7925a5c727A7359DF3033ebc4Be00Ec9885',
        value:web3.toWei('5','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });

it("白名单 白名单测试 输入金额符合要求 冻结状态", function() {
    return Crowdsale.deployed().then(function(instance) {

      let result1 = instance.setFreezeStatus(true,{
        from:'0xEd6Ac7925a5c727A7359DF3033ebc4Be00Ec9885'
      })
      return instance.sendCode({
        from:'0xEd6Ac7925a5c727A7359DF3033ebc4Be00Ec9885',
        value:web3.toWei('2','ether')
      });
    }).then(function(result) {
      dealReturnStatus(result);
    });
  });

});
