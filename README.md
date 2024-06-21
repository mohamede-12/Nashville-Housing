# Nashville Housing Data
This repository is a showcase of some data cleaning I did on a dataset I found on Kaggle using SQL

## First Step of Cleaning Data
While initially diagnosing this data, I noticed some duplicate Parcel IDs. Some of the Parcel IDs had an address and some didn't so in this case I joined the table with itself to check which were missing. 
Once I found the missing values, I populated the table with the values from the second table with the same Parcel ID.

## Separating Addresses 
Separating addresses into address, city, and state is important for multiple reasons. The next part of my cleaning was to do that for the property and owner's addresses. All the properties were located in Tennessee so there is no need for a state column but I did include a column for the address and city. For the owner's address, I included all 3. 

## Changing 'Y' and 'N' values to 'Yes' and 'No'
After separating the addresses I noted in the SoldAsVacant column that they have four distinct values. I didn't want to have both 'Y' and 'Yes' because they are redundant. I changed the values of Y and N to Yes and No respectively. This will make this column only have two distinct values. 

## Dropping Columns
The last step I did was to drop columns I didn't use. I dropped the tax district, property address, and owner address columns. I dropped these columns because I separated the address columns and the tax district column didn't seem important. 


Now that the data is clean, it can be used to conduct a proper analysis and be used for visualizations. 


## Questions?
If you have any questions or concerns, please don't hesitate to reach out! All my information can be found on my profile. Thank you for checking out my project :)
