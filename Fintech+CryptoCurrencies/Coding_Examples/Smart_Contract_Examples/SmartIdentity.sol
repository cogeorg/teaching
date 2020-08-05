
pragma solidity ^0.4.0;

contract SmartIdentity {

    address private owner;
    address private override;
    uint private blocklock;
    string public encryptionPublicKey;
    string public signingPublicKey;

    uint constant BLOCK_HEIGHT = 20;

    // Status Level Scale: 
    uint constant ERROR_EVENT = 1;          //Error: error conditions
    uint constant WARNING_EVENT = 2;        //Warning: warning conditions
    uint constant SIG_CHANGE_EVENT = 3;     //Significant Change: Significant change to condition
    uint constant INFO_EVENT = 4;           //Informational: informational messages
    uint constant DEBUG_EVENT = 5;          //Verbose: debug-level messages

    struct Attribute {
        bytes32 hash;
        mapping(bytes32 => Endorsement) endorsements;
    }

    struct Endorsement {
        address endorser;
        bytes32 hash;
        bool accepted;
    }

    modifier onlyBy(address _account) {
        require (msg.sender == _account);
        _;
    }

    /*
     * Modifier to prevent change if the block height is too low.
     * This should be made longer to better protect the contract from significant
     * ownership changes.
     */

    modifier checkBlockLock() {
        require (blocklock + BLOCK_HEIGHT < block.number);
        _;
    }

    modifier blockLock() {
        blocklock = block.number;
        _;
    }

    mapping(bytes32 => Attribute) public attributes;

    event ChangeNotification(address indexed sender, uint status, bytes32 notificationMsg);


    function SmartIdentity() {
        owner = msg.sender;
        override = owner;
        blocklock = block.number - BLOCK_HEIGHT;
    }

    // Uses Status Level Scale defined above
    function sendEvent(uint _status, bytes32 _notification) internal returns(bool) {
        ChangeNotification(owner, _status, _notification);
        return true;
    }

     /* This function gives the override address the ability to change owner.
      * This could allow the identity to be moved to a multi-sig contract.
      */

    function setOwner(address _newowner) 
    onlyBy(override) 
    checkBlockLock() 
    blockLock() 
    returns(bool) {
        owner = _newowner;
        sendEvent(SIG_CHANGE_EVENT, "Owner has been changed");
        return true;
    }

    /*
     * Cosmetic function for the override account holder to check that their
     * permissions on the contract have been set correctly.
     */

    function getOwner() 
    onlyBy(override) 
    returns(address) {
        return owner;
    }

    /*
     * The override address is another ethereum address that can reset the owner.
     * In practice this could either be another multi-sig account, or another
     * smart contract that this control could be delegated to.
     */

    function setOverride(address _override) 
    onlyBy(owner)
    checkBlockLock()
    blockLock()
    returns(bool) {
        override = _override;
        sendEvent(SIG_CHANGE_EVENT, "Override has been changed");
        return true;
    }

    /*
     * This function removes the override by the owner 
     */

    function removeOverride() 
    onlyBy(owner) 
    checkBlockLock() 
    blockLock() 
    returns(bool) {
        override = owner;
        sendEvent(SIG_CHANGE_EVENT, "Override has been removed");
        return true;
    }

    /*
     * Adds an attribute, with an empty list of endorsements.
     */

    function addAttribute(bytes32 _hash) 
    onlyBy(owner) 
    checkBlockLock() 
    returns(bool) {
        var attribute = attributes[_hash];
        if (attribute.hash == _hash) {
            sendEvent(SIG_CHANGE_EVENT, "A hash exists for the attribute");
            revert();
        }
        attribute.hash = _hash;
        sendEvent(INFO_EVENT, "Attribute has been added");
        return true;
    }

    /*
     * Removes an attribute from a contract.
     */

    function removeAttribute(bytes32 _hash)
    onlyBy(owner)
    checkBlockLock()
    returns(bool) {
        var attribute = attributes[_hash];
        if (attribute.hash != _hash) {
            sendEvent(WARNING_EVENT, "Hash not found for attribute");
            revert();
        }
        delete attributes[_hash];
        sendEvent(SIG_CHANGE_EVENT, "Attribute has been removed");
        return true;
    }

    /**
     * This updates an attribute by removing the old one first, and then
     * adding the new one.
     */

    function updateAttribute(bytes32 _oldhash, bytes32 _newhash) 
    onlyBy(owner)
    checkBlockLock()
    returns(bool) {
        sendEvent(DEBUG_EVENT, "Attempting to update attribute");
        removeAttribute(_oldhash);
        addAttribute(_newhash);
        sendEvent(SIG_CHANGE_EVENT, "Attribute has been updated");
        return true;
    }

    /*
     * Adds an endorsement to an attribute; must provide a valid attributeHash.
     */

    function addEndorsement(bytes32 _attributeHash, bytes32 _endorsementHash) returns(bool) {
        var attribute = attributes[_attributeHash];
        if (attribute.hash != _attributeHash) {
            sendEvent(ERROR_EVENT, "Attribute doesnt exist");
            revert();
        }
        var endorsement = attribute.endorsements[_endorsementHash];
        if (endorsement.hash == _endorsementHash) {
            sendEvent(ERROR_EVENT, "Endorsement already exists");
            revert();
        }
        endorsement.hash = _endorsementHash;
        endorsement.endorser = msg.sender;
        endorsement.accepted = false;
        sendEvent(INFO_EVENT, "Endorsement has been added");
        return true;
    }

    /*
     * Owner can mark an endorsement as accepted.
     */

    function acceptEndorsement(bytes32 _attributeHash, bytes32 _endorsementHash) 
    onlyBy(owner) 
    returns(bool) {
        var attribute = attributes[_attributeHash];
        var endorsement = attribute.endorsements[_endorsementHash];
        endorsement.accepted = true;
        sendEvent(SIG_CHANGE_EVENT, "Endorsement has been accepted");
    }

    /*
     * Checks that an endorsement _endorsementHash exists for the attribute _attributeHash.
     */

    function checkEndorsementExists(bytes32 _attributeHash, bytes32 _endorsementHash) returns(bool) {
        var attribute = attributes[_attributeHash];
        if (attribute.hash != _attributeHash) {
            sendEvent(ERROR_EVENT, "Attribute doesnt exist");
            return false;
        }
        var endorsement = attribute.endorsements[_endorsementHash];
        if (endorsement.hash != _endorsementHash) {
            sendEvent(ERROR_EVENT, "Endorsement doesnt exist");
            return false;
        }
        if (endorsement.accepted == true) {
            sendEvent(INFO_EVENT, "Endorsement exists for attribute");
            return true;
        } else {
            sendEvent(ERROR_EVENT, "Endorsement hasnt been accepted");
            return false;
        }
    }

    /*
     * Allows only the person who gave the endorsement the ability to remove it.
     */

    function removeEndorsement(bytes32 _attributeHash, bytes32 _endorsementHash) returns(bool) {
        var attribute = attributes[_attributeHash];
        var endorsement = attribute.endorsements[_endorsementHash];
        if (msg.sender == endorsement.endorser) {
            delete attribute.endorsements[_endorsementHash];
            sendEvent(SIG_CHANGE_EVENT, "Endorsement removed");
            return true;
        }
        if (msg.sender == owner && endorsement.accepted == false) {
            delete attribute.endorsements[_endorsementHash];
            sendEvent(SIG_CHANGE_EVENT, "Endorsement denied");
            return true;
        }
        sendEvent(SIG_CHANGE_EVENT, "Endorsement removal failed");
        revert();
    }

    /*
     * Allows only the account owner to create or update encryptionPublicKey.
     */

    function setEncryptionPublicKey(string _myEncryptionPublicKey) 
    onlyBy(owner) 
    checkBlockLock() 
    returns(bool) {
        encryptionPublicKey = _myEncryptionPublicKey;
        sendEvent(SIG_CHANGE_EVENT, "Encryption key added");
        return true;
    }

    /*
     * Allows only the account owner to create or update signingPublicKey.
     */

    function setSigningPublicKey(string _mySigningPublicKey) 
    onlyBy(owner) 
    checkBlockLock() 
    returns(bool) {
        signingPublicKey = _mySigningPublicKey;
        sendEvent(SIG_CHANGE_EVENT, "Signing key added");
        return true;
    }

    /*
     * Kills the contract and prevents further actions on it.
     */
     
    function kill() 
    onlyBy(owner) 
    returns(uint) {
        suicide(owner);
        sendEvent(WARNING_EVENT, "Contract killed");
    }
}