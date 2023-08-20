// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract IdentityManagement {
    enum UserType {
        Hospital,
        Doctor,
        Patient
    }
    enum Sex {
        Male,
        Female
    }

    struct Hospital {
        address id;
        string name;
        string location;
        uint rooms;
        uint noOfBeds;
        string specialization;
        address[] doctors;
        address[] pendingDoctors;
        address[] patients;
        bool isOpdAvailable;
        bool isVerified;
    }

    struct Doctor {
        address id;
        string name;
        uint age;
        Sex sex;
        string specialization;
        uint yearsOfExperience;
        address[] patients;
        address hospital;
        bool isVerified;
    }

    struct Patient {
        address id;
        string name;
        uint age;
        Sex sex;
        string phone;
        address doctorAssigned;
        Document[] documents;
    }

    struct Document {
        string documentName;
        string documentType; // Add this for the type
        string ipfsHash;
        address holder; // Patient's address
        address doctorAddress; // Add this for doctor's address
        address hospitalAddress; // Add this for hospital's address
    }

    mapping(address => Hospital) public hospitals;
    mapping(address => Doctor) public doctors;
    mapping(address => Patient) public patients;
    address[] public hospitalAddresses;
    address[] public doctorAddresses;
    Document[] public allDocuments;

    function registerHospital(string memory _name) public {
        require(
            hospitals[msg.sender].id == address(0),
            "Hospital already exists!"
        );

        Hospital storage hospital = hospitals[msg.sender];
        hospital.name = _name;
        hospital.id = msg.sender;
        hospital.isVerified = false;
        hospitalAddresses.push(msg.sender); // Add the new hospital to the list
    }

    function registerDoctor(
        string memory _name,
        uint _age,
        Sex _sex,
        string memory _specialization,
        uint _yearsOfExperience
    ) public {
        require(doctors[msg.sender].id == address(0), "doctor already exists!");

        Doctor storage doctor = doctors[msg.sender];
        doctor.id = msg.sender;
        doctor.name = _name;
        doctor.age = _age;
        doctor.sex = _sex;
        doctor.specialization = _specialization;
        doctor.yearsOfExperience = _yearsOfExperience;
        doctor.isVerified = false;
        doctorAddresses.push(msg.sender);
    }

    function approveDoctor(address _doctorAddress) public {
        require(
            hospitals[msg.sender].id != address(0),
            "Only hospitals can approve doctors!"
        );
        require(
            !doctors[_doctorAddress].isVerified,
            "Doctor is already verified!"
        );

        // Remove doctor from the pending list
        address[] storage pendingDoctors = hospitals[msg.sender].pendingDoctors;
        for (uint i = 0; i < pendingDoctors.length; i++) {
            if (pendingDoctors[i] == _doctorAddress) {
                pendingDoctors[i] = pendingDoctors[pendingDoctors.length - 1];
                pendingDoctors.pop();
                break;
            }
        }

        // Add doctor to the approved list
        doctors[_doctorAddress].isVerified = true;
        hospitals[msg.sender].doctors.push(_doctorAddress);
    }

    function associateDoctor(address _hospitalAddress) public {
        require(
            doctors[msg.sender].hospital == address(0),
            "Doctor is already associated with a hospital!"
        );

        hospitals[_hospitalAddress].pendingDoctors.push(msg.sender);
        doctors[msg.sender].hospital = _hospitalAddress;
    }

    function getAllHospitals() public view returns (Hospital[] memory) {
        Hospital[] memory hospitalList = new Hospital[](
            hospitalAddresses.length
        );
        for (uint i = 0; i < hospitalAddresses.length; i++) {
            hospitalList[i] = hospitals[hospitalAddresses[i]];
        }
        return hospitalList;
    }

    function getAllDoctors() public view returns (Doctor[] memory) {
        Doctor[] memory doctorList = new Doctor[](doctorAddresses.length);
        for (uint i = 0; i < doctorAddresses.length; i++) {
            doctorList[i] = doctors[doctorAddresses[i]];
        }
        return doctorList;
    }

    function getHospital(
        address _address
    )
        public
        view
        returns (
            address,
            string memory,
            address[] memory,
            address[] memory,
            address[] memory,
            string memory,
            bool
        )
    {
        Hospital storage hospital = hospitals[_address];
        return (
            hospital.id,
            hospital.name,
            hospital.doctors,
            hospital.pendingDoctors,
            hospital.patients,
            hospital.specialization,
            hospital.isVerified
        );
    }

    function getDoctor(
        address _address
    )
        public
        view
        returns (
            address,
            string memory,
            uint,
            Sex,
            string memory,
            uint,
            address[] memory,
            address,
            bool
        )
    {
        Doctor storage doctor = doctors[_address];
        return (
            doctor.id,
            doctor.name,
            doctor.age,
            doctor.sex,
            doctor.specialization,
            doctor.yearsOfExperience,
            doctor.patients,
            doctor.hospital,
            doctor.isVerified
        );
    }

    function registerPatient(
        string memory _name,
        uint _age,
        Sex _sex,
        string memory _phone
    ) public {
        require(
            patients[msg.sender].id == address(0),
            "Patient already exists!"
        );

        Patient storage patient = patients[msg.sender];
        patient.id = msg.sender;
        patient.name = _name;
        patient.age = _age;
        patient.sex = _sex;
        patient.phone = _phone;
    }

    event DocumentAdded(address indexed patient, string documentName, string ipfsHash);


    function addDocument(
        string memory _documentName,
        string memory _documentType,
        string memory _ipfsHash,
        address _doctorAddress,
        address _hospitalAddress
    ) public {
        
        Document memory newDoc;
        newDoc.documentName = _documentName;
        newDoc.documentType = _documentType;
        newDoc.ipfsHash = _ipfsHash;
        newDoc.holder = msg.sender;
        newDoc.doctorAddress = _doctorAddress;
        newDoc.hospitalAddress = _hospitalAddress;



        patients[msg.sender].documents.push(newDoc);
        allDocuments.push(newDoc); // Add document to the global list
    }

    function getPatient(address _address) public view returns (Patient memory) {
        return patients[_address];
    }

    // for the current patient
    function getDocuments(
        address _address
    ) public view returns (Document[] memory) {
        return patients[_address].documents;
    }

    // for the patient with specific id
    function getPatientDocuments(
        address _patientId
    ) public view returns (Document[] memory) {
        return patients[_patientId].documents;
    }

    // for all documents
    function getAllTheDocuments() public view returns (Document[] memory) {
        return allDocuments;
    }

    // to get document for a specific hospital
    function getDocumentsByHospital(
        address _hospitalAddress
    ) public view returns (Document[] memory) {
        uint count = 0;

        // Count documents for the specific hospital
        for (uint i = 0; i < allDocuments.length; i++) {
            if (allDocuments[i].hospitalAddress == _hospitalAddress) {
                count++;
            }
        }

        Document[] memory documents = new Document[](count);
        count = 0;

        // Populate the results
        for (uint i = 0; i < allDocuments.length; i++) {
            if (allDocuments[i].hospitalAddress == _hospitalAddress) {
                documents[count] = allDocuments[i];
                count++;
            }
        }

        return documents;
    }
}
