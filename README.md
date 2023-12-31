### 🚀 Hospital Identity Management on the Blockchain
This project focuses on streamlining hospital, doctor, and patient identity management using Ethereum smart contracts. It allows for easy document storage, verification of doctors by hospitals, and patient management. Moreover, it efficiently handles the registration and retrieval of medical documents, providing seamless access to essential healthcare details.

### 📜 Contract Overview
The core of the project lies in the Ethereum smart contract titled IdentityManagement. This contract manages different entities, including hospitals, doctors, and patients, and their various attributes:

- [x] Hospitals: Address, name, location, number of rooms, specialization, doctors associated, pending doctors, and more.
- [x] Doctors: Address, name, age, gender, specialization, years of experience, affiliated hospital, and list of patients.
- [x] Patients: Address, name, age, gender, phone, assigned doctor, and list of documents.
- [x] Documents: Document name, type, IPFS hash for actual file storage, the patient's address, the doctor's address, and the hospital's address.

The contract provides functionalities for:

(i) Registration of hospitals, doctors, and patients.<br/>
(ii) Associating doctors with hospitals.<br/>
(iii) Adding, retrieving, and managing medical documents.<br/>
(iv) Accessing lists of all hospitals and doctors.<br/>
(v) Various getters for accessing specific details about entities.<br/>

### 🔧 Setup & Running the Project
<b>Prerequisites:<b><br/>
(1) Node.js and npm installed<br/>
(2) Ethereum Wallet like Metamask<br/>
(3) Ethereum development environment, like Truffle or Remix<br/>
