const Splitter = artifacts.require('Splitter');
const Bluebird = require('bluebird');

Bluebird.promisifyAll(web3.eth, {
    suffix: "Promise"
});

contract('Splitter', async (accounts) => {
    it('should evenly split a deposit', async () => {
        let instance = await Splitter.deployed();
        let me = accounts[0];
        let bob = accounts[1];
        let alice = accounts[2];
        let tx = await instance.split(bob, alice, {from: me, value: 100});
        let bobBalance = await instance.availableBalances(bob, {from: me})
        let aliceBalance = await instance.availableBalances(alice, {from: me})
        assert.equal(bobBalance.toString(10), '50');
        assert.equal(aliceBalance.toString(10), '50');
    })

    it('should save my remainder', async () => {
        let instance = await Splitter.deployed();
        let me = accounts[0];
        let bob = accounts[1];
        let alice = accounts[2];
        let tx = await instance.split(bob, alice, {
            from: me,
            value: 101
        });
        let bobBalance = await instance.availableBalances(bob, {
            from: me
        })
        let aliceBalance = await instance.availableBalances(alice, {
            from: me
        })
        let meBalance = await instance.availableBalances(me, {
            from: me
        })
        assert.equal(bobBalance.toString(10), '100');
        assert.equal(aliceBalance.toString(10), '100');
        assert.equal(meBalance.toString(10), '1');
    })

    it('should let me withdraw a balance', async () => {
        let instance = await Splitter.deployed();
        let me = accounts[0];
        let bob = accounts[1];
        let alice = accounts[2];
        let bobAccountBalance = await web3.eth.getBalancePromise(bob);
        let bobContractBalance = await instance.availableBalances(bob);
        let resp = await instance.withdraw({ from: bob});
        let tx = await web3.eth.getTransactionPromise(resp.tx);
        let txCost = tx.gasPrice.mul(resp.receipt.gasUsed);
        let bobNewContractBalance = await instance.availableBalances(bob);
        let bobNewAccountBalance = await web3.eth.getBalancePromise(bob);
        assert.equal(bobAccountBalance.toString(10), '100000000000000000000')
        assert.equal(bobContractBalance.toString(10), '100')
        assert.equal(bobNewContractBalance.toString(10), '0')
        assert.equal(bobNewAccountBalance.toString(10), web3.toBigNumber('100000000000000000100') - txCost)
    })
})