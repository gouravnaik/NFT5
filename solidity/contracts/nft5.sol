//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@opengsn/contracts/src/ERC2771Recipient.sol";

contract Nft5 is Ownable, ERC721URIStorage, ERC2771Recipient {
    using Counters for Counters.Counter;
    Counters.Counter private _freeNftIds;
    Counters.Counter private _paidNftIds;
    using SafeERC20 for IERC20;

    uint256 public FREE_MAX_SUPPLY;
    uint256 public PAID_MAX_SUPPLY;   
    uint public MINT_FEE; 

    event collectFeeEvent(address indexed owner, address indexed _tokenAddress, uint256 balance);

    function _msgSender() internal view override(Context, ERC2771Recipient) returns(address) {
        return ERC2771Recipient._msgSender();
    } 

    function _msgData() internal view override(Context, ERC2771Recipient) returns(bytes memory) 
    {
            return ERC2771Recipient._msgData();
    }

    constructor(address _forwarder, string memory tokenName, string memory tokenSymbol) ERC721(tokenName, tokenSymbol) {
        _setTrustedForwarder(_forwarder);
    }

    function setFreeMaxSupply(uint256 supply) public onlyOwner() returns(uint256) {
        FREE_MAX_SUPPLY = supply;
        return FREE_MAX_SUPPLY;
    }

    function setPaidMaxSupply(uint256 supply) public onlyOwner() returns(uint256) {
        PAID_MAX_SUPPLY = supply;
        return PAID_MAX_SUPPLY;
    }

    function setMintFee(uint256 fee) public onlyOwner() returns(uint256) {
        MINT_FEE = fee * 1 ether;
        return MINT_FEE;
    }

    function freeMint(string memory _tokenUri) public  returns (uint256) {
        require(freeTotalSupply() <= FREE_MAX_SUPPLY-1, "Registration Closed");
        require(bytes(_tokenUri).length != 0, "Token Uri Required");

        _freeNftIds.increment();
        uint256 newItemId = _freeNftIds.current();
        _safeMint(_msgSender(), newItemId);
        _setTokenURI(newItemId, _tokenUri);
        return newItemId;
    }

     function paidMint(string memory _tokenUri) public payable returns (uint256) {
        require(paidTotalSupply() <= PAID_MAX_SUPPLY-1, "Registration Closed");
        require(bytes(_tokenUri).length != 0, "Token Uri Required");
        require(msg.value == MINT_FEE, "Insufficient MATIC");

        _paidNftIds.increment();
        uint256 newItemId = _paidNftIds.current();
        _safeMint(_msgSender(), newItemId);
        _setTokenURI(newItemId, _tokenUri);
        return newItemId;
    }

    function collectFee(address _tokenAddress) external onlyOwner() {
        uint256 balance;
        if (_tokenAddress == address(0)) {
            balance = address(this).balance;
            payable(owner()).transfer(balance);
        } else {
            IERC20 emergencyToken = IERC20(_tokenAddress);
            balance = emergencyToken.balanceOf(address(this));
            emergencyToken.safeTransfer(owner(), balance);
        }

        emit collectFeeEvent(owner(), _tokenAddress, balance);
    }

    function freeTotalSupply() public view returns (uint256) {
        return _freeNftIds.current();
    }

    function paidTotalSupply() public view returns (uint256) {
        return _paidNftIds.current();
    }

    function totalSupply() public view returns (uint256) {
        return (_freeNftIds.current() + _paidNftIds.current());
    }

}