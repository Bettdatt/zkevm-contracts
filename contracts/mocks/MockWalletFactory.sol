// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.8.29;

contract MockWalletFactory {
    bytes private constant WALLET_CREATION_CODE =
        hex"608060405234801561001057600080fd5b5060405161029f38038061029f8339818101604052810190610032919061009e565b803055506100cb565b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600061006b82610040565b9050919050565b61007b81610060565b811461008657600080fd5b50565b60008151905061009881610072565b92915050565b6000602082840312156100b4576100b361003b565b5b60006100c284828501610089565b91505092915050565b6101c5806100da6000396000f3fe6080604052600436106100225760003560e01c806390611127146100a857610076565b36610076573373ffffffffffffffffffffffffffffffffffffffff16347f606834f57405380c4fb88d1f4850326ad3885f014bab3b568dfbf7a041eef73860405161006c90610113565b60405180910390a3005b60006100806100d3565b90503660008037600080366000845af43d6000803e80600081146100a3573d6000f35b3d6000fd5b3480156100b457600080fd5b506100bd6100d3565b6040516100ca9190610174565b60405180910390f35b60003054905090565b600082825260208201905092915050565b50565b60006100fd6000836100dc565b9150610108826100ed565b600082019050919050565b6000602082019050818103600083015261012c816100f0565b9050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b600061015e82610133565b9050919050565b61016e81610153565b82525050565b60006020820190506101896000830184610165565b9291505056fea2646970667358221220d43fa02972046db2bc81804ebf600d5b46b97e55c738ea899a28224e111b588564736f6c63430008110033";

    function getAddress(address _mainModule, bytes32 _salt) public view returns (address _address) {
        bytes32 _hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(abi.encodePacked(WALLET_CREATION_CODE, uint256(uint160(_mainModule))))
            )
        );
        return address(uint160(uint256(_hash)));
    }

    // slither-disable-next-line locked-ether
    function deploy(address _mainModule, bytes32 _salt) public payable returns (address _contract) {
        bytes memory code = abi.encodePacked(WALLET_CREATION_CODE, uint256(uint160(_mainModule)));
        // solhint-disable-next-line no-inline-assembly
        assembly {
            _contract := create2(callvalue(), add(code, 32), mload(code), _salt)
        }
        // check deployment success
        // solhint-disable-next-line custom-errors
        require(_contract != address(0), "WalletFactory: deployment failed");
    }
}
