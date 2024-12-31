// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4;


contract RealEstate {
  

    // Define a structure to represent a property
    struct Property {
        uint price; // Price of the property in wei
        address owner; // Address of the current owner
        bool forSale; // Whether the property is listed for sale
        string name; // Name of the property
        string description; // Description of the property
        string location; // Location of the property
    }

    // Mapping to store property details by their unique ID
    mapping(uint => Property) public properties;

    // Array to store all property IDs
    uint256[] public propertyIds;

    // Event to log when a property is sold
    event PropertySold(uint propertyId);

    // Function to list a property for sale
    function listPropertyForSale(
        uint _propertyId,
        uint _price,
        string memory _name,
        string memory _description,
        string memory _location
    ) public {
        // Create a new property instance
        Property memory newProperty = Property({
            price: _price,
            owner: msg.sender,
            forSale: true,
            name: _name,
            description: _description,
            location: _location
        });

        // Store the property in the mapping
        properties[_propertyId] = newProperty;

        // Add the property ID to the list
        propertyIds.push(_propertyId);
    }

    // Function to buy a property
    function buyProperty(uint _propertyId) public payable {
        // Fetch the property from storage
        Property storage property = properties[_propertyId];

        // Ensure the property is for sale
        require(property.forSale, "Property is not for sale");

        // Ensure the buyer has sent enough funds
        require(msg.value >= property.price, "Insufficient funds");

        // Transfer ownership to the buyer
        property.owner = msg.sender;

        // Mark the property as not for sale
        property.forSale = false;

        // Transfer the payment to the current owner
        payable(property.owner).transfer(property.price);

        // Emit an event for the sale
        emit PropertySold(_propertyId);
    }
}
