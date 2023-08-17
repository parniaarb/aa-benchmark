pragma solidity ^0.8.0;

import "./TestBase.sol";
import {EtherspotWalletFactory, EtherspotWallet} from "etherspot-prime-contracts/wallet/EtherspotWalletFactory.sol";
bytes constant BCNMY_FACTORY_BYTECODE = hex'608060405234801561001057600080fd5b50600436106100725760003560e01c8063d668bfa811610050578063d668bfa8146100e3578063da9fc1ae146100f6578063daf0dfc81461010957600080fd5b8063088924ef1461007757806331c884df146100a75780633b3cb143146100bc575b600080fd5b61008a6100853660046105fe565b610130565b6040516001600160a01b0390911681526020015b60405180910390f35b6100af6102bd565b60405161009e919061064c565b61008a7f000000000000000000000000a04eef9bbfd8f64d5218d4f3a3d03e8282810f5181565b61008a6100f13660046105fe565b6102e7565b61008a61010436600461067f565b610408565b61008a7f00000000000000000000000000006b7e42e01957da540dc6a8f7c30c4d816af581565b60008061013c84610550565b90506000818051906020012084604051602001610163929190918252602082015260400190565b60405160208183030381529060405280519060200120905060006040518060200161018d906105d5565b601f1982820381018352601f9091011660408190526101da91906001600160a01b037f00000000000000000000000000006b7e42e01957da540dc6a8f7c30c4d816af516906020016106a1565b6040516020818303038152906040529050818151826020016000f593506001600160a01b0384166102525760405162461bcd60e51b815260206004820152601360248201527f437265617465322063616c6c206661696c65640000000000000000000000000060448201526064015b60405180910390fd5b8251156102735760008060008551602087016000895af10361027357600080fd5b84866001600160a01b0316856001600160a01b03167f8967dcaa00d8fcb9bb2b5beff4aaf8c020063512cf08fbe11fec37a1e3a150f260405160405180910390a450505092915050565b6060604051806020016102cf906105d5565b601f1982820381018352601f90910116604052919050565b6000806102f384610550565b9050600060405180602001610307906105d5565b601f1982820381018352601f90910116604081905261035491906001600160a01b037f00000000000000000000000000006b7e42e01957da540dc6a8f7c30c4d816af516906020016106a1565b60408051808303601f1901815282825284516020958601208584015282820196909652805180830382018152606080840183528151918601919091208751978601979097207fff0000000000000000000000000000000000000000000000000000000000000060808501523090911b6bffffffffffffffffffffffff19166081840152609583019690965260b5808301969096528051808303909601865260d5909101905250825192019190912092915050565b6000806040518060200161041b906105d5565b601f1982820381018352601f90910116604081905261046891906001600160a01b037f00000000000000000000000000006b7e42e01957da540dc6a8f7c30c4d816af516906020016106a1565b60405160208183030381529060405290508051816020016000f091506001600160a01b0382166104da5760405162461bcd60e51b815260206004820152601260248201527f4372656174652063616c6c206661696c656400000000000000000000000000006044820152606401610249565b60006104e584610550565b8051909150156105095760008060008351602085016000885af10361050957600080fd5b836001600160a01b0316836001600160a01b03167f9a6cbf173278cf7dfadb45414d824f7828c0c94479f1b15e45453653070cf65760405160405180910390a35050919050565b6040516001600160a01b0380831660248301527f000000000000000000000000a04eef9bbfd8f64d5218d4f3a3d03e8282810f5116604482015260609060640160408051601f198184030181529190526020810180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1663784d200b60e11b17905292915050565b61012d806106c483390190565b80356001600160a01b03811681146105f957600080fd5b919050565b6000806040838503121561061157600080fd5b61061a836105e2565b946020939093013593505050565b60005b8381101561064357818101518382015260200161062b565b50506000910152565b602081526000825180602084015261066b816040850160208701610628565b601f01601f19169190910160400192915050565b60006020828403121561069157600080fd5b61069a826105e2565b9392505050565b600083516106b3818460208801610628565b919091019182525060200191905056fe608060405234801561001057600080fd5b5060405161012d38038061012d83398101604081905261002f91610090565b6001600160a01b0381166100895760405162461bcd60e51b815260206004820152601e60248201527f496e76616c696420696d706c656d656e746174696f6e20616464726573730000604482015260640160405180910390fd5b30556100c0565b6000602082840312156100a257600080fd5b81516001600160a01b03811681146100b957600080fd5b9392505050565b605f806100ce6000396000f3fe608060405230543660008037600080366000845af43d6000803e8080156024573d6000f35b3d6000fdfea2646970667358221220a7977748230fa5c96134083773f708cfbe78723c07e58051ac6bd8c4877a4d5a64736f6c63430008110033a2646970667358221220e54d8de7095529f44af43e19294085fe71ccb1ce3c7d1c47c13b7751d7adb1d464736f6c63430008110033';
bytes constant BCNMY_IMPL_BYTECODE = hex'6080604052600436106102a05760003560e01c80638da5cb5b1161016e578063c399ec88116100cb578063f08a03231161007f578063f698da2511610064578063f698da25146108c2578063fc7d3d791461092b578063ffa1ad741461093e57610350565b8063f08a032314610882578063f09a4016146108a257610350565b8063cc2f8452116100b0578063cc2f845214610814578063e009cfde14610842578063ed516d511461086257610350565b8063c399ec88146107df578063c4ca3a9c146107f457610350565b8063aaf10f4211610122578063ac85dca711610107578063ac85dca714610777578063affed0e014610797578063b0d691fe146107ac57610350565b8063aaf10f4214610743578063abc1b7451461075757610350565b80639e5d4c49116101535780639e5d4c49146106e3578063a18f51e514610703578063a9059cbb1461072357610350565b80638da5cb5b146106a3578063912ccaa3146106c357610350565b80633a871cdd1161021c5780635229073f116101d0578063610b5925116101b5578063610b5925146106285780637455ce3c14610648578063856dfd991461065b57610350565b80635229073f146105cd5780635c0ba299146105fb57610350565b8063468721a711610201578063468721a7146105925780634a58db19146105b25780634d44560d146105ba57610350565b80633a871cdd146105455780633d46b8191461056557610350565b806313af4035116102735780631626ba7e116102585780631626ba7e146104b95780632d9ad53d146104f25780633408e4701461051257610350565b806313af40351461045e578063141a468c1461047e57610350565b80610772146103b65780618f2d146103d857806301ffc9a7146103f8578063025b22bc1461043e57610350565b36610350576001600160a01b037f00000000000000000000000000006b7e42e01957da540dc6a8f7c30c4d816af51630036103225760405162461bcd60e51b815260206004820152601d60248201527f6f6e6c7920616c6c6f776564207669612064656c656761746543616c6c00000060448201526064015b60405180910390fd5b604051349033907ed05ab44e279ac59e855cb75dc2ae23b200ad994797b6f1f028f96a46ecce0290600090a3005b34801561035c57600080fd5b507f6c9a6c4a39284e37ed1cf53d337577d14212a4870fb976a4366c693b939918d480548061038757005b36600080373360601b365260008060143601600080855af190503d6000803e806103b0573d6000fd5b503d6000f35b3480156103c257600080fd5b506103d66103d1366004612bba565b610987565b005b3480156103e457600080fd5b506103d66103f3366004612c5b565b6109d6565b34801561040457600080fd5b50610429610413366004612d0b565b6001600160e01b0319166301ffc9a760e01b1490565b60405190151581526020015b60405180910390f35b34801561044a57600080fd5b506103d6610459366004612d28565b610ae2565b34801561046a57600080fd5b506103d6610479366004612d28565b610bea565b34801561048a57600080fd5b506104ab610499366004612d45565b60336020526000908152604090205481565b604051908152602001610435565b3480156104c557600080fd5b506104d96104d4366004612e2a565b610d96565b6040516001600160e01b03199091168152602001610435565b3480156104fe57600080fd5b5061042961050d366004612d28565b610e63565b34801561051e57600080fd5b507f00000000000000000000000000000000000000000000000000000000000138816104ab565b34801561055157600080fd5b506104ab610560366004612e71565b610e9b565b34801561057157600080fd5b506104ab610580366004612d45565b60009081526033602052604090205490565b34801561059e57600080fd5b506104296105ad366004612ed4565b610f04565b6103d6611003565b6103d66105c8366004612f3e565b611083565b3480156105d957600080fd5b506105ed6105e8366004612ed4565b611139565b604051610435929190612fba565b34801561060757600080fd5b5061061b6106163660046130b5565b61116f565b604051610435919061310d565b34801561063457600080fd5b506103d6610643366004612d28565b6112c9565b610429610656366004613120565b6113ef565b34801561066757600080fd5b507f6c9a6c4a39284e37ed1cf53d337577d14212a4870fb976a4366c693b939918d4545b6040516001600160a01b039091168152602001610435565b3480156106af57600080fd5b5060325461068b906001600160a01b031681565b3480156106cf57600080fd5b506103d66106de366004612c5b565b61162d565b3480156106ef57600080fd5b506103d66106fe366004612bba565b61163b565b34801561070f57600080fd5b506104ab61071e366004613195565b611647565b34801561072f57600080fd5b506103d661073e366004612f3e565b6117e0565b34801561074f57600080fd5b50305461068b565b34801561076357600080fd5b506104ab6107723660046131f3565b61187e565b34801561078357600080fd5b506103d66107923660046132bb565b611951565b3480156107a357600080fd5b506104ab6119e7565b3480156107b857600080fd5b507f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278961068b565b3480156107eb57600080fd5b506104ab611a7f565b34801561080057600080fd5b506104ab61080f3660046132fc565b611ace565b34801561082057600080fd5b5061083461082f366004612f3e565b611b47565b60405161043592919061336d565b34801561084e57600080fd5b506103d661085d3660046133ca565b611c40565b34801561086e57600080fd5b506103d661087d366004612e2a565b611d72565b34801561088e57600080fd5b506103d661089d366004612d28565b612004565b3480156108ae57600080fd5b506103d66108bd3660046133ca565b61207b565b3480156108ce57600080fd5b506104ab604080517f47e79534a245952e8b16893a336b85a3d9ea9fa8c573f3d803afb92a794692186020820152469181019190915230606082015260009060800160405160208183030381529060405280519060200120905090565b610429610939366004613120565b612110565b34801561094a57600080fd5b5061061b6040518060400160405280600581526020017f312e302e3000000000000000000000000000000000000000000000000000000081525081565b61098f61211d565b6109d0848484848080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525061218392505050565b50505050565b6109de61211d565b8415806109eb5750848314155b806109f65750828114155b15610a2557604051630a0c0a9160e31b8152600481018690526024810184905260448101829052606401610319565b60005b85811015610ad957610ad1878783818110610a4557610a45613403565b9050602002016020810190610a5a9190612d28565b868684818110610a6c57610a6c613403565b90506020020135858585818110610a8557610a85613403565b9050602002810190610a979190613419565b8080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525061218392505050565b600101610a28565b50505050505050565b6032546001600160a01b03163314801590610afd5750333014155b15610b1d576040516308a0b0a560e11b8152336004820152602401610319565b6001600160a01b038116610b735760405162461bcd60e51b815260206004820152601660248201527f416464726573732063616e6e6f74206265207a65726f000000000000000000006044820152606401610319565b6001600160a01b0381163b610ba657604051630c76093760e01b81526001600160a01b0382166004820152602401610319565b308054908290556040516001600160a01b0380841691908316907faa3f731066a578e5f39b4215468d826cdd15373cbc0dfc9cb9bdc649718ef7da90600090a35050565b6032546001600160a01b03163314801590610c055750333014155b15610c25576040516308a0b0a560e11b8152336004820152602401610319565b6001600160a01b038116610c4c57604051639b15e16f60e01b815260040160405180910390fd5b306001600160a01b03821603610cca5760405162461bcd60e51b815260206004820152603460248201527f536d617274204163636f756e743a3a206e6577205369676e61746f727920616460448201527f64726573732063616e6e6f742062652073656c660000000000000000000000006064820152608401610319565b6032546001600160a01b0390811690821603610d4e5760405162461bcd60e51b815260206004820152602f60248201527f6e6577205369676e61746f727920616464726573732063616e6e6f742062652060448201527f73616d65206173206f6c64206f6e6500000000000000000000000000000000006064820152608401610319565b60328054908290556040516001600160a01b0391821691831690829030907ff2c2b1b5312b1e31ad49a7d85acd6322ae6facc51488810b882ecdb4df861cd490600090a45050565b6032546000906001600160a01b03163b15610e2557603254604051630b135d3f60e11b81526001600160a01b0390911690631626ba7e90610ddd9086908690600401613460565b602060405180830381865afa158015610dfa573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610e1e9190613479565b9050610e5d565b610e2f83836121a1565b6032546001600160a01b03918216911603610e525750630b135d3f60e11b610e5d565b506001600160e01b03195b92915050565b600060016001600160a01b03831614801590610e5d5750506001600160a01b0390811660009081526020819052604090205416151590565b6000336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d27891614610ee857604051635dac3db760e11b8152336004820152602401610319565b610ef284846121c5565b9050610efd826123b6565b9392505050565b60003360011480610f2b5750336000908152602081905260409020546001600160a01b0316155b15610f4b576040516321ac7c5f60e01b8152336004820152602401610319565b610f58858585855a612401565b90508015610fcf577f8c014e41cffd68ba64f3e7830b8b2e4ee860509d8deab25ebbcbba2f0405e2da3386868686604051610f979594939291906134ce565b60405180910390a160405133907f6895c13664aa4f67288b25d7a21d7aaa34916e355fb9b6fae0a139a9085becb890600090a2610ffb565b60405133907facd2c8702804128fdb0db2bb49f6d127dd0181c13fd45dbfe16de0930e2bd37590600090a25b949350505050565b7f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278960405163b760faf960e01b81523060048201526001600160a01b03919091169063b760faf99034906024016000604051808303818588803b15801561106857600080fd5b505af115801561107c573d6000803e3d6000fd5b5050505050565b6032546001600160a01b031633146110b05760405163d4ed9a1760e01b8152336004820152602401610319565b7f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278960405163040b850f60e31b81526001600160a01b03848116600483015260248201849052919091169063205c287890604401600060405180830381600087803b15801561111d57600080fd5b505af1158015611131573d6000803e3d6000fd5b505050505050565b6000606061114986868686610f04565b915060405160203d0181016040523d81523d6000602083013e8091505094509492505050565b606060007fda033865d68bf4a40a5a7cb4159a99e33dba8569e65ea3e38222eb12d9e66eee60001b856000015186604001518760600151805190602001208860200151896080015189600001518a602001518b604001518c606001518d608001518d6040516020016111ec9c9b9a99989796959493929190613519565b60408051601f1981840301815291905280516020909101209050601960f81b600160f81b61126c604080517f47e79534a245952e8b16893a336b85a3d9ea9fa8c573f3d803afb92a794692186020820152469181019190915230606082015260009060800160405160208183030381529060405280519060200120905090565b6040517fff0000000000000000000000000000000000000000000000000000000000000093841660208201529290911660218301526022820152604281018290526062016040516020818303038152906040529150509392505050565b6112d1612508565b6001600160a01b03811615806112f057506001600160a01b0381166001145b156113195760405163cadb248f60e01b81526001600160a01b0382166004820152602401610319565b6001600160a01b03818116600090815260208190526040902054161561135d5760405163b29d459560e01b81526001600160a01b0382166004820152602401610319565b600060208181527fada5013122d395ba3c54772283fb069b10426056ef8ca54750cb9bb552a59e7d80546001600160a01b0385811680865260408087208054939094166001600160a01b03199384161790935560019095528254168417909155519182527fecdf3a3effea5783a3c4c2140e677577666428d44ed9d474a0b3a4c9943f8440910160405180910390a150565b600060026031540361141457604051637465d9d160e01b815260040160405180910390fd5b600260315560005a6001600090815260336020527f10f6f77027d502f219862b0303542eb5dd005b06fa23ff4d1775aaa45bbf947780549293509091829161146e91899189919085611465836135a8565b9190505561116f565b80516020820120925090506114838286611d72565b506114b2603f60068860800151901b61149c91906135c1565b60808801516114ad906109c46135e3565b61252a565b6114be906101f46135e3565b5a101561151d575a6114ef603f60068960800151901b6114de91906135c1565b60808901516114ad906109c46135e3565b6114fb906101f46135e3565b604051633b4daac960e01b815260048101929092526024820152604401610319565b61155d8660000151876040015188606001518960200151896020015160001461154a578a60800151612401565b6109c45a61155891906135f6565b612401565b92508215801561156f57506080860151155b801561157d57506020850151155b156115b65760808601516020860151604051631061f87f60e31b8152600481019290925260248201528315156044820152606401610319565b6000856020015160001461161e576115ed5a6115d290856135f6565b8751602089015160408a015160608b015160808c0151612540565b905080827f3fd74c38c9f1b6f0499c6d0128fbf77a796dbacc7eda0369b13006dc977bb56b60405160405180910390a35b50506001603155509392505050565b6111318686868686866109d6565b6109d084848484610987565b6000836000036116995760405162461bcd60e51b815260206004820152601b60248201527f696e76616c696420746f6b656e4761735072696365466163746f7200000000006044820152606401610319565b60005a905060006001600160a01b038416156116b557836116b7565b325b90506001600160a01b03851661173a5760003a88106116d6573a6116d8565b875b6116e28a8c6135e3565b6116ec9190613609565b9050600080600080600085875af19050806117335760405163190eecf360e31b8152600060048201526001600160a01b038416602482015260448101839052606401610319565b50506117a2565b600086886117488b8d6135e3565b6117529190613609565b61175c91906135c1565b905061176986838361269a565b6117a05760405163190eecf360e31b81526001600160a01b0380881660048301528316602482015260448101829052606401610319565b505b5a82039250826040516020016117ba91815260200190565b60408051601f198184030181529082905262461bcd60e51b82526103199160040161310d565b6032546001600160a01b0316331461180d5760405163d4ed9a1760e01b8152336004820152602401610319565b6001600160a01b038216611834576040516309293b1960e41b815260040160405180910390fd5b600080600080600085875af19050806118795760405163190eecf360e31b8152600060048201526001600160a01b038416602482015260448101839052606401610319565b505050565b6000806040518060a001604052808f6001600160a01b031681526020018b60018111156118ad576118ad613496565b81526020018e81526020018d8d8080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525050509082525060209081018b90526040805160a0810182528b81529182018a905281018890526001600160a01b0380881660608301528616608082015290915061193682828661116f565b80519060200120925050509c9b505050505050505050505050565b6032546001600160a01b0316331461197e5760405163d4ed9a1760e01b8152336004820152602401610319565b6001600160a01b0382166119a5576040516309293b1960e41b815260040160405180910390fd5b6119b083838361269a565b6118795760405163190eecf360e31b81526001600160a01b0380851660048301528316602482015260448101829052606401610319565b604051631aab3f0d60e11b8152306004820152600060248201819052906001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278916906335567e1a906044015b602060405180830381865afa158015611a56573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190611a7a9190613620565b905090565b6040516370a0823160e01b81523060048201526000906001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278916906370a0823190602401611a39565b6000805a9050611b17878787878080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525089925050505a612401565b611b3457604051632b3f6d1160e21b815260040160405180910390fd5b5a604080519183036020830152016117ba565b606060008267ffffffffffffffff811115611b6457611b64612d5e565b604051908082528060200260200182016040528015611b8d578160200160208202803683370190505b506001600160a01b0380861660009081526020819052604081205492945091165b6001600160a01b03811615801590611bd057506001600160a01b038116600114155b8015611bdb57508482105b15611c325780848381518110611bf357611bf3613403565b6001600160a01b039283166020918202929092018101919091529181166000908152918290526040909120541681611c2a816135a8565b925050611bae565b908352919491935090915050565b611c48612508565b6001600160a01b0381161580611c6757506001600160a01b0381166001145b15611c905760405163cadb248f60e01b81526001600160a01b0382166004820152602401610319565b6001600160a01b03828116600090815260208190526040902054811690821614611cf8576001600160a01b0382811660008181526020819052604090819020549051633103525b60e21b81528484166004820152921660248301526044820152606401610319565b6001600160a01b03818116600081815260208181526040808320805488871685528285208054919097166001600160a01b03199182161790965592849052825490941690915591519081527faab4fa2b463f581b2b32cb3b7e3b704b9ce37cc209b5fb4d77e593ace4054276910160405180910390a15050565b604181511015611dc45760405162461bcd60e51b815260206004820152601960248201527f496e76616c6964207369676e617475726573206c656e677468000000000000006044820152606401610319565b600080600080611de7856020810151604082015160419092015160ff1692909190565b9195509350915060ff8416600003611f2c5750816041821015611e2e576040516338a245ff60e11b8152600481018390526000602482018190526044820152606401610319565b6020828601810151865190918290611e479086906135e3565b611e5191906135e3565b1115611e845785516040516338a245ff60e11b815260048101859052602481018390526044810191909152606401610319565b604051630b135d3f60e11b808252878501602001916001600160a01b03851690631626ba7e90611eba908c908690600401613460565b602060405180830381865afa158015611ed7573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190611efb9190613479565b6001600160e01b03191614611f25578060405163605d348960e01b8152600401610319919061310d565b5050611fbf565b601e8460ff161115611faf57611fa7611f46600486613639565b8484611f9f8a6040517f19457468657265756d205369676e6564204d6573736167653a0a3332000000006020820152603c8101829052600090605c01604051602081830303815290604052805190602001209050919050565b9291906127eb565b509050611fbf565b611fbb868585856127eb565b5090505b6032546001600160a01b03828116911614611131576032546040516310b5d43760e21b81526001600160a01b0380841660048301529091166024820152604401610319565b61200c612508565b7f6c9a6c4a39284e37ed1cf53d337577d14212a4870fb976a4366c693b939918d454612037826128af565b816001600160a01b0316816001600160a01b03167f06be9a1bea257286cf2afa8205ed494ca9d6a4b41aa58d04238deebada20fb0c60405160405180910390a35050565b6032546001600160a01b0316156120a7576040516393360fbf60e01b8152306004820152602401610319565b6001600160a01b0382166120ce57604051639b15e16f60e01b815260040160405180910390fd5b603280546001600160a01b0319166001600160a01b0384161790556120f2816128af565b61210c6000604051806020016040528060008152506128fa565b5050565b6000610ffb8484846113ef565b336001600160a01b037f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d2789161480159061216157506032546001600160a01b03163314155b15612181576040516332dbd3c760e11b8152336004820152602401610319565b565b60008082516020840185875af16040513d6000823e8161107c573d81fd5b60008060006121b085856129c4565b915091506121bd81612a09565b509392505050565b600036816121d66060860186613419565b909250905080156122dd5760006121f06004828486613652565b6121f99161367c565b90506361a2b3b760e01b6001600160e01b03198216016122db57600080806122248560048189613652565b81019061223191906136ac565b6001600160a01b03808416600090815260208190526040902054939650919450925016156122d757604051631179c1f560e11b81526001600160a01b038416906322f383ea90612287908c908c9060040161376a565b6020604051808303816000875af11580156122a6573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906122ca9190613620565b9650505050505050610e5d565b5050505b505b6000612336856040517f19457468657265756d205369676e6564204d6573736167653a0a3332000000006020820152603c8101829052600090605c01604051602081830303815290604052805190602001209050919050565b9050612386612349610140880188613419565b8080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525085939250506121a19050565b6032546001600160a01b039081169116146123a75760019350505050610e5d565b50600095945050505050565b50565b80156123b35760405133906000199083906000818181858888f193505050503d80600081146109d0576040519150601f19603f3d011682016040523d82523d6000602084013e6109d0565b6000600183600181111561241757612417613496565b0361242f576000808551602087018986f4905061243f565b600080855160208701888a87f190505b80156124a457836040516124539190613883565b604051809103902085876001600160a01b03167f81d12fffced46c214dfae8ab8fa0b9f7b69f70c9d500e33f612f2105deb261ee868660405161249792919061389f565b60405180910390a46124ff565b836040516124b29190613883565b604051809103902085876001600160a01b03167f3ddd038f78c876172d5dbfd730b14c9f8692dfa197ef104eaac6df3f85a0874a86866040516124f692919061389f565b60405180910390a45b95945050505050565b333014612181576040516301478e3360e21b8152336004820152602401610319565b60008183116125395781610efd565b5090919050565b6000836000036125925760405162461bcd60e51b815260206004820152601b60248201527f696e76616c696420746f6b656e4761735072696365466163746f7200000000006044820152606401610319565b60006001600160a01b038316156125a957826125ab565b325b90506001600160a01b03841661262b573a86106125c8573a6125ca565b855b6125d4888a6135e3565b6125de9190613609565b9150600080600080600086865af19050806126255760405163190eecf360e31b8152600060048201526001600160a01b038316602482015260448101849052606401610319565b5061268f565b8486612637898b6135e3565b6126419190613609565b61264b91906135c1565b915061265884828461269a565b61268f5760405163190eecf360e31b81526001600160a01b0380861660048301528216602482015260448101839052606401610319565b509695505050505050565b60006001600160a01b0384166126f25760405162461bcd60e51b815260206004820152601d60248201527f746f6b656e2063616e206e6f74206265207a65726f20616464726573730000006044820152606401610319565b6000846001600160a01b03163b1161274c5760405162461bcd60e51b815260206004820152601c60248201527f746f6b656e20636f6e747261637420646f65736e2774206578697374000000006044820152606401610319565b604080516001600160a01b03851660248201526044808201859052825180830390910181526064909101909152602080820180517bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1663a9059cbb60e01b178152825160009182896127105a03f13d80156127ce57602081146127d657600093506127e1565b8193506127e1565b600051158215171593505b5050509392505050565b6000807f7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a083111561282257506000905060036128a6565b6040805160008082526020820180845289905260ff881692820192909252606081018690526080810185905260019060a0016020604051602081039080840390855afa158015612876573d6000803e3d6000fd5b5050604051601f1901519150506001600160a01b03811661289f576000600192509250506128a6565b9150600090505b94509492505050565b6001600160a01b0381166128d65760405163dd449f5f60e01b815260040160405180910390fd5b7f6c9a6c4a39284e37ed1cf53d337577d14212a4870fb976a4366c693b939918d455565b600160009081526020527fada5013122d395ba3c54772283fb069b10426056ef8ca54750cb9bb552a59e7d546001600160a01b03161561294d5760405163df8cc4e360e01b815260040160405180910390fd5b600160008181526020527fada5013122d395ba3c54772283fb069b10426056ef8ca54750cb9bb552a59e7d80546001600160a01b03191690911790556001600160a01b0382161561210c576129a78260008360015a612401565b61210c5760405163032e3a3960e51b815260040160405180910390fd5b60008082516041036129fa5760208301516040840151606085015160001a6129ee878285856127eb565b94509450505050612a02565b506000905060025b9250929050565b6000816004811115612a1d57612a1d613496565b03612a255750565b6001816004811115612a3957612a39613496565b03612a865760405162461bcd60e51b815260206004820152601860248201527f45434453413a20696e76616c6964207369676e617475726500000000000000006044820152606401610319565b6002816004811115612a9a57612a9a613496565b03612ae75760405162461bcd60e51b815260206004820152601f60248201527f45434453413a20696e76616c6964207369676e6174757265206c656e677468006044820152606401610319565b6003816004811115612afb57612afb613496565b036123b35760405162461bcd60e51b815260206004820152602260248201527f45434453413a20696e76616c6964207369676e6174757265202773272076616c604482015261756560f01b6064820152608401610319565b6001600160a01b03811681146123b357600080fd5b8035612b7381612b53565b919050565b60008083601f840112612b8a57600080fd5b50813567ffffffffffffffff811115612ba257600080fd5b602083019150836020828501011115612a0257600080fd5b60008060008060608587031215612bd057600080fd5b8435612bdb81612b53565b935060208501359250604085013567ffffffffffffffff811115612bfe57600080fd5b612c0a87828801612b78565b95989497509550505050565b60008083601f840112612c2857600080fd5b50813567ffffffffffffffff811115612c4057600080fd5b6020830191508360208260051b8501011115612a0257600080fd5b60008060008060008060608789031215612c7457600080fd5b863567ffffffffffffffff80821115612c8c57600080fd5b612c988a838b01612c16565b90985096506020890135915080821115612cb157600080fd5b612cbd8a838b01612c16565b90965094506040890135915080821115612cd657600080fd5b50612ce389828a01612c16565b979a9699509497509295939492505050565b6001600160e01b0319811681146123b357600080fd5b600060208284031215612d1d57600080fd5b8135610efd81612cf5565b600060208284031215612d3a57600080fd5b8135610efd81612b53565b600060208284031215612d5757600080fd5b5035919050565b634e487b7160e01b600052604160045260246000fd5b60405160a0810167ffffffffffffffff81118282101715612d9757612d97612d5e565b60405290565b600082601f830112612dae57600080fd5b813567ffffffffffffffff80821115612dc957612dc9612d5e565b604051601f8301601f19908116603f01168101908282118183101715612df157612df1612d5e565b81604052838152866020858801011115612e0a57600080fd5b836020870160208301376000602085830101528094505050505092915050565b60008060408385031215612e3d57600080fd5b82359150602083013567ffffffffffffffff811115612e5b57600080fd5b612e6785828601612d9d565b9150509250929050565b600080600060608486031215612e8657600080fd5b833567ffffffffffffffff811115612e9d57600080fd5b84016101608187031215612eb057600080fd5b95602085013595506040909401359392505050565b803560028110612b7357600080fd5b60008060008060808587031215612eea57600080fd5b8435612ef581612b53565b935060208501359250604085013567ffffffffffffffff811115612f1857600080fd5b612f2487828801612d9d565b925050612f3360608601612ec5565b905092959194509250565b60008060408385031215612f5157600080fd5b8235612f5c81612b53565b946020939093013593505050565b60005b83811015612f85578181015183820152602001612f6d565b50506000910152565b60008151808452612fa6816020860160208601612f6a565b601f01601f19169290920160200192915050565b8215158152604060208201526000610ffb6040830184612f8e565b600060a08284031215612fe757600080fd5b612fef612d74565b90508135612ffc81612b53565b815261300a60208301612ec5565b602082015260408201356040820152606082013567ffffffffffffffff81111561303357600080fd5b61303f84828501612d9d565b6060830152506080820135608082015292915050565b600060a0828403121561306757600080fd5b61306f612d74565b9050813581526020820135602082015260408201356040820152606082013561309781612b53565b606082015260808201356130aa81612b53565b608082015292915050565b600080600060e084860312156130ca57600080fd5b833567ffffffffffffffff8111156130e157600080fd5b6130ed86828701612fd5565b9350506130fd8560208601613055565b915060c084013590509250925092565b602081526000610efd6020830184612f8e565b600080600060e0848603121561313557600080fd5b833567ffffffffffffffff8082111561314d57600080fd5b61315987838801612fd5565b94506131688760208801613055565b935060c086013591508082111561317e57600080fd5b5061318b86828701612d9d565b9150509250925092565b60008060008060008060c087890312156131ae57600080fd5b8635955060208701359450604087013593506060870135925060808701356131d581612b53565b915060a08701356131e581612b53565b809150509295509295509295565b6000806000806000806000806000806000806101608d8f03121561321657600080fd5b6132208d35612b53565b8c359b5060208d01359a5067ffffffffffffffff60408e0135111561324457600080fd5b6132548e60408f01358f01612b78565b909a50985061326560608e01612ec5565b975060808d0135965060a08d0135955060c08d0135945060e08d013593506101008d013561329281612b53565b92506132a16101208e01612b68565b91506101408d013590509295989b509295989b509295989b565b6000806000606084860312156132d057600080fd5b83356132db81612b53565b925060208401356132eb81612b53565b929592945050506040919091013590565b60008060008060006080868803121561331457600080fd5b853561331f81612b53565b945060208601359350604086013567ffffffffffffffff81111561334257600080fd5b61334e88828901612b78565b9094509250613361905060608701612ec5565b90509295509295909350565b604080825283519082018190526000906020906060840190828701845b828110156133af5781516001600160a01b03168452928401929084019060010161338a565b5050506001600160a01b039490941692019190915250919050565b600080604083850312156133dd57600080fd5b82356133e881612b53565b915060208301356133f881612b53565b809150509250929050565b634e487b7160e01b600052603260045260246000fd5b6000808335601e1984360301811261343057600080fd5b83018035915067ffffffffffffffff82111561344b57600080fd5b602001915036819003821315612a0257600080fd5b828152604060208201526000610ffb6040830184612f8e565b60006020828403121561348b57600080fd5b8151610efd81612cf5565b634e487b7160e01b600052602160045260246000fd5b600281106134ca57634e487b7160e01b600052602160045260246000fd5b9052565b60006001600160a01b03808816835280871660208401525084604083015260a0606083015261350060a0830185612f8e565b905061350f60808301846134ac565b9695505050505050565b6000610180820190508d82526001600160a01b03808e1660208401528c60408401528b606084015261354e608084018c6134ac565b8960a08401528860c08401528760e08401528661010084015280861661012084015280851661014084015250826101608301529d9c50505050505050505050505050565b634e487b7160e01b600052601160045260246000fd5b6000600182016135ba576135ba613592565b5060010190565b6000826135de57634e487b7160e01b600052601260045260246000fd5b500490565b80820180821115610e5d57610e5d613592565b81810381811115610e5d57610e5d613592565b8082028115828204841417610e5d57610e5d613592565b60006020828403121561363257600080fd5b5051919050565b60ff8281168282160390811115610e5d57610e5d613592565b6000808585111561366257600080fd5b8386111561366f57600080fd5b5050820193919092039150565b6001600160e01b031981358181169160048510156136a45780818660040360031b1b83161692505b505092915050565b6000806000606084860312156136c157600080fd5b83356136cc81612b53565b925060208401359150604084013567ffffffffffffffff8111156136ef57600080fd5b61318b86828701612d9d565b6000808335601e1984360301811261371257600080fd5b830160208101925035905067ffffffffffffffff81111561373257600080fd5b803603821315612a0257600080fd5b81835281816020850137506000828201602090810191909152601f909101601f19169091010190565b6040815261378b6040820161377e85612b68565b6001600160a01b03169052565b6020830135606082015260006137a460408501856136fb565b6101608060808601526137bc6101a086018385613741565b92506137cb60608801886136fb565b9250603f19808786030160a08801526137e5858584613741565b9450608089013560c088015260a089013560e0880152610100935060c089013584880152610120915060e089013582880152610140848a01358189015261382e838b018b6136fb565b95509250818887030184890152613846868685613741565b9550613854818b018b6136fb565b955093505080878603016101808801525050613871838383613741565b93505050508260208301529392505050565b60008251613895818460208701612f6a565b9190910192915050565b604081016138ad82856134ac565b826020830152939250505056fea2646970667358221220c629a8dfa39df68a931ade003f3ac9678b7bd5d18586f74e7a4e8e868cc6b04064736f6c63430008110033';
address constant BCNMY_FACTORY = 0x000000F9eE1842Bb72F6BBDD75E6D3d4e3e9594C;
address constant BCNMY_IMPL = 0x00006B7e42e01957dA540Dc6a8F7C30c4D816af5;

interface SmartAccountFactory {
    function deployCounterFactualAccount(
        address _owner,
        uint256 _index
    ) external returns (address proxy);
    function getAddressForCounterFactualAccount(
        address _owner,
        uint256 _index
    ) external view returns (address _account);
}

interface SmartAccount {
    function executeCall(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external;
}

contract ProfileBcnmy is AAGasProfileBase {
    SmartAccountFactory factory;
    function setUp() external {
        initializeTest();
        factory = SmartAccountFactory(BCNMY_FACTORY);
        vm.etch(BCNMY_FACTORY, BCNMY_FACTORY_BYTECODE);
        vm.etch(BCNMY_IMPL, BCNMY_IMPL_BYTECODE);
        setAccount();
    }

    function fillData(address _to, uint256 _value, bytes memory _data) internal override returns(bytes memory) {
        return abi.encodeWithSelector(
            SmartAccount.executeCall.selector,
            _to,
            _value,
            _data
        );
    }

    function getSignature(UserOperation memory _op) internal override returns(bytes memory) {
        return signUserOpHash(key, _op);
    }

    function createAccount(address _owner) internal override {
        (bool success, bytes memory data) = address(factory).call(abi.encodeWithSelector(factory.deployCounterFactualAccount.selector, _owner, 0));
    }

    function getAccountAddr(address _owner) internal view override returns(IAccount) {
        (bool success, bytes memory data) = address(factory).staticcall(abi.encodeWithSelector(factory.getAddressForCounterFactualAccount.selector, _owner, 0));
        require(success, "getAccountAddr failed");
        return IAccount(abi.decode(data, (address)));
    }

    function getInitCode(address _owner) internal view override returns(bytes memory) {
        return abi.encodePacked(
            address(factory),
            abi.encodeWithSelector(
                factory.deployCounterFactualAccount.selector,
                _owner,
                0
            )
        );
    }
}
