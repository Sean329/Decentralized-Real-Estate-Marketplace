pragma solidity >=0.4.21 <0.6.0;

import './ERC721Mintable.sol';

// TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
interface Verifier {
    function verifyTx(
            uint[2] calldata a,
            uint[2][2] calldata b,
            uint[2] calldata c,
            uint[2] calldata input
        ) external returns (bool r);
}



// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is ERC721Mintable {

    Verifier verifier;

// TODO define a solutions struct that can hold an index & an address
    struct Solution {
        uint256 index;
        address accountSolution;
    }

// TODO define an array of the above struct
    Solution[] private _solutions;


// TODO define a mapping to store unique solutions submitted
    mapping(bytes32 => Solution) private _uniqueSolutions;


// TODO Create an event to emit when a solution is added
    event SolutionAdded(address account);

    constructor(address verifierAddress)
    public {
        verifier = Verifier(verifierAddress);
    }


// TODO Create a function to add the solutions to the array and emit the event
    function addSolution(bytes32 solutionId, uint256 tokenId, address accountSolution)
    public {
        _solutions.push(Solution({
            index: tokenId,
            accountSolution: accountSolution
        }));
        _uniqueSolutions[solutionId] = Solution({
            index: tokenId,
            accountSolution: accountSolution
        });
        emit SolutionAdded(accountSolution);
    }


// TODO Create a function to mint new NFT only after the solution has been verified
//  - make sure the solution is unique (has not been used before)
//  - make sure you handle metadata as well as tokenSuplly
    function mintNFT(
        address to,
        uint256 tokenId,
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[2] memory input
    )
    public {
        bytes32 solutionId = getSolutionId(a, b, c, input);
        require(_uniqueSolutions[solutionId].accountSolution == address(0), "Solution already exists");
        require(verifier.verifyTx(a, b, c, input), "Solution is not verified");
        addSolution(solutionId, tokenId, to);
        mint(to, tokenId);
    }

    function getSolutionId(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[2] memory input
    )
    private
    pure
    returns(bytes32) {
        return keccak256(abi.encodePacked(a, b, c, input));
    }

}

  


























