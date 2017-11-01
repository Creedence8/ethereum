>geth --dev console

>geth --dev --rpc --rpcaddr "0.0.0.0" --rpcapi "admin,debug,miner,shh,txpool,personal,eth,net,web3" console

>mist.exe --rpc http://localhost:8545
-----
> personal.newAccount("123") // Создаем новый аккаунт с паролем "123"
"0x07ae7ebb7b9c65b51519fc6561b8a78ad921ed13" // Его адрес

> eth.accounts // Смотрим список аккаунтов
["0x07ae7ebb7b9c65b51519fc6561b8a78ad921ed13"]

> miner.setEtherbase(eth.accounts[0]) // Устанавливаем его в качестве аккаунта для майнинга
true

> eth.coinbase // Проверяем
"0x07ae7ebb7b9c65b51519fc6561b8a78ad921ed13" // Все верно

> miner.start() // Я запускаю майнер не в первый раз, поэтому у меня номера блоков 31,32,...
true
I1005 09:25:44.363901 miner/miner.go:136] Starting mining operation (CPU=2 TOT=3)
I1005 09:25:44.364247 miner/worker.go:539] commit new work on block 31 with 0 txs & 0 uncles. Took 291.8µs

> miner.stop()
true

> eth.getBalance(eth.coinbase) // Проверим баланс в wei
15000000000000000000

> web3.fromWei( eth.getBalance(eth.coinbase) ) Проверим баланс в ether

Also if you want to send almost Z ether from X account to adr Y, you would use;
>eth.sendTransaction({from: x-account, to: y-account, value: web3.toWei(z-value, "ether")})
---

Приступим к открытию контракта. Присвоим адрес контракта в переменную:
> var address = "0x65cA73D13a2cc1dB6B92fd04eb4EBE4cEB70c5eC";

Присвоим интерфейс контракта в переменную:
> var abi = [ { "constant": false, "inputs": [ { "name": "newString", "type": "string" } ], "name": "setString", "outputs": [], "payable": false, "type": "function" }, { "constant": true, "inputs": [], "name": "getString", "outputs": [ { "name": "", "type": "string", "value": "Hello World!" } ], "payable": false, "type": "function" } ];

Создадим объект контракта:
> var contract = web3.eth.contract(abi);

Этот объект может использоваться для открытия существующего контракта либо для деплоя нового. В данном случае нам нужно первое, для этого выполним команду:
> var stringHolder = contract.at(address)

Разблокируйте аккаунт следующей командой(, чтобы платить эфиром за транзакции) 
> web3.personal.unlockAccount(eth.coinbase);

Запустите setString снова с дополнительной опцией, задающей от какого аккаунта выполнять транзакцию
>stringHolder.setString("Hello my baby, hello my honey!", {from: eth.coinbase});

можно отследить транзакцию 
> web3.eth.getTransaction("0x5f9c3a61c79df36776713f7373b902feea802cf6d3903195f8070ff2d376c669");

команда с отправкой транзакции от этого аккаунта
> var uselessWorker = contract.new( {from: eth.coinbase, data: bin, gas: 1000000}, function(e, contract) { if (e) { console.log(e); } else { if (contract.address) { console.log ("mined " + contract.address);  } } });

вычисление примерного количества газа, которое потребуется при вызове функции
> uselessWorker.doWork.estimateGas(1);
 
какая цена газа будет использоваться
> web3.fromWei( eth.gasPrice );
 
Рассчитаем цену за 100 тысяч циклов с нашей ценой, но измененным лимитом газа (параметр gas). 
> web3.fromWei( fixedGasPrice * uselessWorker.doWork.estimateGas(100000, {gas: 100000000}) );

Выполним транзакцию с заданием нашего лимита и цены (но перед этим разблокируем аккаунт)
> transaction = uselessWorker.doWork( 10, { from: eth.coinbase, gas: 42000, gasPrice: fixedGasPrice } );

По номеру транзакции можно отследить ее статус, выполнив:
> result = web3.eth.getTransactionReceipt(transaction);

