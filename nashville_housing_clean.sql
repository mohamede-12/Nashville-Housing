SELECT *
From nashville.nashville_housing;

-- Populate Property Address Data
Select housing_a.ParcelID, housing_a.PropertyAddress, housing_b.ParcelID, housing_b.PropertyAddress, IFNULL(housing_a.PropertyAddress,  housing_b.PropertyAddress) as test
-- IFNULL checks if the first parameter is null, if so it replaces it with the second parameter 
FROM nashville.nashville_housing housing_a
JOIN nashville.nashville_housing housing_b -- JOINING TABLE WITH ITSELF TO CHECK IF ANY OF THE SAME PARCEL IDS HAVE NULL VALUES
	on housing_a.ParcelID = housing_b.ParcelID
    AND housing_a.UniqueID  <> housing_b.UniqueID -- ONLY CHECKING THE SAME PARCEL IDS BUT DIFFERENT UNIQUE IDS. THIS AVOIDS DUPLICATES
WHERE housing_a.PropertyAddress is NULL; -- ONLY CHECKING NULL VALUES 

-- 	What this chunk of code does check the parcel IDs that are the same and then check the Unique IDs. If they are different, then they populate the null Property Address with the address of the populated one. 
-- For example, there are two Parcel IDs with value 092 13 0 322.00. One of them has a null property address and one doesn't. This chunk of code populates the empty one with the same address as the given parcel ID. 
-- So the final step is to plug the address_fill column into the PropertyAddress column that is full of nulls
-- Now that we have what we were looking for, we need to update the table

SET SQL_SAFE_UPDATES = 0;
UPDATE nashville.nashville_housing AS housing_a
	JOIN nashville.nashville_housing AS housing_b
		ON housing_a.ParcelID = housing_b.ParcelID
		AND housing_a.UniqueID <> housing_b.UniqueID
SET housing_a.PropertyAddress = IFNULL(housing_a.PropertyAddress, housing_b.PropertyAddress)
WHERE housing_a.PropertyAddress IS NULL;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking up the address into street name and city
SELECT 
substring_index(nashville_housing.PropertyAddress, ',', 1) as Address, 
substring_index(nashville_housing.PropertyAddress, ',', -1) as City
FROM nashville.nashville_housing;

-- ADDING COLUMN FOR PROPERTY ADDRESS
ALTER TABLE nashville_housing
ADD Propperty_Address Nvarchar(255);

-- INSERTING DATA NEW STREET COLUMN
UPDATE nashville_housing
Set Propperty_Address = substring_index(nashville_housing.PropertyAddress, ',', 1); 

-- CREATING COLUMN FOR CITY
ALTER TABLE nashville_housing
ADD Propperty_City Nvarchar(255);

-- INSERTING DATA FOR NEW CITY COLUMN
UPDATE nashville_housing
Set Propperty_City = substring_index(nashville_housing.PropertyAddress, ',', -1); 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- BREAKING UP OWNER ADDRESS INTO ADDRESS, CITY AND STATE
SELECT
substring_index(nashville_housing.OwnerAddress, ',', 1) as owner_address,
substring_index(substring_index(nashville_housing.OwnerAddress, ',', 2),',' , -1) as owner_city,
substring_index(nashville_housing.OwnerAddress, ',', -1) as owner_state
FROM nashville.nashville_housing;

-- ADDING COLUMN FOR OWNER ADDRESS
ALTER TABLE nashville_housing
ADD Owner_Address Nvarchar(255);

-- INSERTING COLUMN FOR OWNER ADDRESS
UPDATE nashville_housing
Set Owner_Address = substring_index(nashville_housing.OwnerAddress, ',', 1) ;

-- ADDING COLUMN FOR OWNER CITY
ALTER TABLE nashville_housing
ADD Owner_City Nvarchar(255);

-- INSERTING COLUMN FOR OWNER ADDRESS
UPDATE nashville_housing
Set Owner_City = substring_index(substring_index(nashville_housing.OwnerAddress, ',', 2),',' , -1);

-- ADDING COLUMN FOR OWNER STATE
ALTER TABLE nashville_housing
ADD Owner_State Nvarchar(255);

-- INSERTING COLUMN FOR OWNER ADDRESS
UPDATE nashville_housing
Set Owner_State = substring_index(nashville_housing.OwnerAddress, ',', -1) ;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CHANGING Y AND N TO YES AND NO IN "SoldAsVacant" COLUMN

-- Checking values and how often they appear
Select distinct(SoldAsVacant), count(SoldAsVacant)
From nashville.nashville_housing
Group by SoldAsVacant
Order by count(SoldAsVacant);

-- We want to change the 21 "Y" and 151 "N" to yes and no 
SELECT SoldAsVacant,
CASE	When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END
From nashville.nashville_housing;

UPDATE nashville_housing
SET SoldAsVacant = CASE	When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END ;
-- IF YOU RUN THE CODE CHUNK BEFORE THE CASE STATEMENT, YOU CAN SEE THERE ARE ONLY TWO DISTINCT VALUES AS "YES" AND "NO"
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- DROP COLUMNS THAT ARE NOT USED

ALTER TABLE nashville.nashville_housing
DROP COLUMN TaxDistrict;

ALTER TABLE nashville.nashville_housing
DROP COLUMN PropertyAddress;

ALTER TABLE nashville.nashville_housing
DROP COLUMN OwnerAddress;

Select *
From nashville.nashville_housing;