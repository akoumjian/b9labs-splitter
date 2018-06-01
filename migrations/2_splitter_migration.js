var Splitter = artifacts.require("Splitter");

module.exports = function(deployer) {
  deployer.deploy(
      Splitter,
      "0x627306090abaB3A6e1400e9345bC60c78a8BEf57", // alice
      "0xf17f52151EbEF6C7334FAD080c5704D77216b732", // bob
      "0xC5fdf4076b8F3A5357c5E395ab970B5B54098Fef" // carol
    );
};
