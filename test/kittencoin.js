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
        await instance.transfer(accounts[1], 100);
    })

    it("Balance of Account 0: ", async () => {
        const value = await instance.balanceOf.call(accounts[0]);

        assert.equal(value, 1e12 - 100);
    })

    it("Balance of Account 1", async () => {
        const value = await instance.balanceOf.call(accounts[1]);

        assert.equal(value, 99); // Verify The Charity Transfer Occured
    })

    it("Balance of Charity Account", async () => {
        const value = await instance.balanceOf.call(accounts[9]);

        assert.equal(value, 1); // Verify The Charity Transfer Occured
    })   

    it("Transfer Should Happen Here", async () => {
        await instance.transfer(accounts[2], 200);
    })

    it("Balance of Account 0: ", async () => {
        const value = await instance.balanceOf.call(accounts[0]);

        assert.equal(value, 1e12 - 300);
    })

    it("Balance of Account 2", async () => {
        const value = await instance.balanceOf.call(accounts[2]);

        assert.equal(value, 198);
    })

    it("Balance of Charity Account", async () => {
        const value = await instance.balanceOf.call(accounts[9]);

        assert.equal(value, 3); // Verify The Charity Transfer Occured
    })   
})