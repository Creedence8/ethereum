To compile the solidity code run:
>solcjs <contract>.sol --bin --abi --optimize -o <output-dir>/

The web3j Command Line Tools tools ship with a command line utility for generating the smart contract function wrappers:
>web3j solidity generate /path/to/<smart-contract>.bin /path/to/<smart-contract>.abi -o /path/to/src/main/java -p com.your.organisation.name

Construction and deployment of smart contracts happens with the deploy method:
>YourSmartContract contract = YourSmartContract.deploy(
        <web3j>, <credentials>, GAS_PRICE, GAS_LIMIT,
        <initialValue>,
        <param1>, ..., <paramN>);
