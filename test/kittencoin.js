const KittethCoin = artifacts.require('KittethCoin');

contract("KittethCoin", (accounts) => {
    before(async () => {
        instance = await KittethCoin.deployed();
    })
    
    it("should return my owner", async () => {
        const value = await instance.getOwner.call();

        assert.equal(value, accounts[0]);
    })

    it("should return my decimals", async () => {
        const value = await instance.decimals.call();

        assert.equal(value, 18);
    })

    it("should return my symbol", async () => {
        const value = await instance.symbol.call();

        assert.equal(value, "KITTCOIN");
    })

    it("should return my name", async () => {
        const value = await instance.name.call();

        assert.equal(value, "KittethCoin");
    })

    it("should return my total supply", async () => {
        const value = await instance.totalSupply.call();

        assert.equal(value, 1e12);
    })

    it("should return my account total", async () => {
        const value = await instance.balanceOf.call(accounts[0]);

        assert.equal(value, 1e12);
    })

    it("Transfer Should Happen Here", async () => {
        let value = await instance.transfer.call(accounts[1], 100, {from: accounts[0]});

        assert.equal(value, true, "Transfer is Not Complete");

        const value2 = await instance.balanceOf.call(accounts[1]);

        assert.equal(value2, 100, "Woof 1: " + value2);

        const value3 = await instance.balanceOf.call(accounts[0]);

        assert.equal(value3, 100, "Woof 2: " + value3);

    })
})