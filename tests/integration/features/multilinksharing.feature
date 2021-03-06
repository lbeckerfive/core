Feature: multilinksharing

	Background:
		Given using api version "1"
		Given using old dav path

	Scenario: Creating three public shares of a folder
		Given user "user0" exists
		And As an "user0"
		And creating a share with
			| path | FOLDER |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| publicUpload | true |
			| permissions | 15 |
			| name | sharedlink1 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | FOLDER |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| publicUpload | true |
			| permissions | 15 |
			| name | sharedlink2 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | FOLDER |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| publicUpload | true |
			| permissions | 15 |
			| name | sharedlink3 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		When Updating last share with
			| permissions | 1 |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And user "user0" checks public shares of folder "/FOLDER"
			| /FOLDER | 15 | sharedlink2 |
			| /FOLDER | 15 | sharedlink1 |
			| /FOLDER | 1 | sharedlink3 |

	Scenario: Creating three public shares of a file
		Given user "user0" exists
		And As an "user0"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink1 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink2 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink3 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		When Updating last share with
			| permissions | 1 |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And user "user0" checks public shares of file "/textfile0.txt"
			| /textfile0.txt | 1 | sharedlink2 |
			| /textfile0.txt | 1 | sharedlink1 |
			| /textfile0.txt | 1 | sharedlink3 |

	Scenario: Check that updating password doesn't remove name of links
		Given user "user0" exists
		And As an "user0"
		And creating a share with
			| path | FOLDER |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| publicUpload | true |
			| permissions | 15 |
			| name | sharedlink1 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | FOLDER |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| publicUpload | true |
			| permissions | 15 |
			| name | sharedlink2 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		When Updating last share with
			| password | newpassword |
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And user "user0" checks public shares of folder "/FOLDER"
			| /FOLDER | 15 | sharedlink2 |
			| /FOLDER | 15 | sharedlink1 |

	Scenario: Deleting a file deletes also its public links
	 Given user "user0" exists
		And As an "user0"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink1 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink2 |
		And User "user0" deletes file "/textfile0.txt"
		And the HTTP status code should be "204"
		When User "user0" uploads file "data/textfile.txt" to "/textfile0.txt"
		Then the HTTP status code should be "201"
		And user "user0" checks public shares of file "/textfile0.txt"
			| | | |

	Scenario: Deleting one public share of a file doesn't affect the rest
		Given user "user0" exists
		And As an "user0"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink1 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink2 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink3 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		When user "user0" deletes public share named "sharedlink2" in file "/textfile0.txt"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And user "user0" checks public shares of file "/textfile0.txt"
			| /textfile0.txt | 1 | sharedlink1 |
			| /textfile0.txt | 1 | sharedlink3 |

	Scenario: Overwriting a file doesn't remove its public shares
		Given user "user0" exists
		And As an "user0"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink1 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | textfile0.txt |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| permissions | 1 |
			| name | sharedlink2 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		When User "user0" uploads file "data/textfile.txt" to "/textfile0.txt"
		Then user "user0" checks public shares of file "/textfile0.txt"
			| /textfile0.txt | 1 | sharedlink1 |
			| /textfile0.txt | 1 | sharedlink2 |

	Scenario: Renaming a folder doesn't remove its public shares
		Given user "user0" exists
		And As an "user0"
		And creating a share with
			| path | FOLDER |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| publicUpload | true |
			| permissions | 15 |
			| name | sharedlink1 |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"
		And creating a share with
			| path | FOLDER |
			| shareType | 3 |
			| password | publicpw |
			| expireDate | +3 days |
			| publicUpload | true |
			| permissions | 15 |
			| name | sharedlink2 |
		When User "user0" moves folder "/FOLDER" to "/FOLDER_RENAMED"
		Then user "user0" checks public shares of file "/FOLDER_RENAMED"
			| /FOLDER_RENAMED | 15 | sharedlink1 |
			| /FOLDER_RENAMED | 15 | sharedlink2 |
