//等额本息每月还款计算
//本金，总期数(月)，年利率
function monthIncome(invest, totalMonth, yearRate) {
    var monthRate = yearRate/totalMonth;
    var monthIncome = invest * monthRate * Math.pow(1 + monthRate, totalMonth) / (Math.pow(1 + monthRate, totalMonth) - 1);
    console.log(monthIncome);
    return monthIncome.toFixed(4);
}
//on browser console 
//test
monthIncome(52000,12,0.083);
